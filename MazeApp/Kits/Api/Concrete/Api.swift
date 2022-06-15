import Foundation

class Api: ApiProtocol {
    typealias Dependencies = HasMainQueue
    let dependencies: Dependencies
    
    init(dependencies: Dependencies = DependencyContainer()) {
        self.dependencies = dependencies
    }
    func execute<E: Decodable>(
        endpoint: ApiEndpointExposable,
        session: URLSessionable,
        jsonDecoder: JSONDecoder,
        completion: @escaping (Result<Success<E>, ApiError>) -> Void
    ) -> URLSessionTask? {
        let request: URLRequest
        do {
            try request = makeRequest(with: endpoint)
        } catch {
            completion(.failure(.badRequest))
            return nil
        }
        let task = session.dataTask(with: request, completionHandler: { responseBody, response, error in
            self.handle(
                request: request,
                responseBody: responseBody,
                response: response,
                error: error,
                jsonDecoder: jsonDecoder,
                completion: completion
            )
        })
        
        task.resume()
        
        return task
    }
    
    private func makeRequest(with endpoint: ApiEndpointExposable) throws -> URLRequest {
        let urlString = endpoint.absoluteStringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? endpoint.absoluteStringUrl
        var urlComponent = URLComponents(string: urlString)
        if endpoint.method == .get && endpoint.parameters.isNotEmpty {
            urlComponent?.queryItems = endpoint.parameters
                .map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }
        
        guard let url = urlComponent?.url else {
            throw ApiError.malformedRequest("Unable to parse url")
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 15
        request.addValue(endpoint.contentType.rawValue, forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = endpoint.method.rawValue
        
        return request
    }
    
    private func handle<E: Decodable>(
        request: URLRequest,
        responseBody: Data?,
        response: URLResponse?,
        error: Error?,
        jsonDecoder: JSONDecoder,
        completion: @escaping (Result<Success<E>, ApiError>) -> Void
    ) {
        print("\(response?.debugDescription ?? "")\n\(self.prettyPrint(responseBody))")
        dependencies.mainQueue.async {
            if let error = error as NSError?,
               error.code == NSURLErrorCancelled {
                completion(.failure(.cancelled))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.connectionFailure))
                return
            }
            
            guard let status = HTTPStatusCode(rawValue: httpResponse.statusCode) else {
                completion(.failure(.unknown))
                return
            }
            let result: Result<Success<E>, ApiError> = self.evaluateResult(status: status, jsonDecoder: jsonDecoder, responseBody: responseBody)
            completion(result)
        }
    }
    
    private func evaluateResult<E: Decodable>(
        status: HTTPStatusCode,
        jsonDecoder: JSONDecoder,
        responseBody: Data?
    ) -> Result<Success<E>, ApiError> {
        let result: Result<Success<E>, ApiError>
        switch status {
        case .ok..<HTTPStatusCode.redirection:
            result = handleSuccess(responseBody: responseBody, jsonDecoder: jsonDecoder)
        case .redirection..<HTTPStatusCode.badRequest:
            result = .failure(.redirectionNotAllowed)
        case .badRequest..<HTTPStatusCode.internalServerError:
            result = .failure(.badRequest)
        case .internalServerError..<HTTPStatusCode.notValidStatus:
            result = .failure(.serverError)
        default:
            result = .failure(.otherErrors)
        }
        return result
    }
}

private extension Api {
    func handleSuccess<E: Decodable>(responseBody: Data?, jsonDecoder: JSONDecoder) -> Result<Success<E>, ApiError> {
        switch E.self {
        case is Data.Type:
            return contentData(responseBody)
        default:
            return decodeContentData(responseBody, jsonDecoder: jsonDecoder)
        }
    }
    
    func contentData<E: Decodable>(_ responseBody: Data?) -> Result<Success<E>, ApiError> {
        guard let response = responseBody as? E else {
            return .failure(.bodyNotFound)
        }
        
        let success = Success(model: response, data: responseBody)
        return .success(success)
    }
    
    func decodeContentData<E: Decodable>(_ responseBody: Data?, jsonDecoder: JSONDecoder) -> Result<Success<E>, ApiError> {
        do {
            let decoded = try jsonDecoder.decode(E.self, from: responseBody ?? Data())
            let result = Success(model: decoded, data: responseBody)
            return .success(result)
        } catch {
            return .failure(.decodeError(error))
        }
    }
}

extension Api {
    private func prettyPrint(_ jsonData: Data?) -> String {
        guard let data = jsonData else {
            return ""
        }

        do {
            let jsonObj = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            guard JSONSerialization.isValidJSONObject(jsonObj) else {
                return String(data: data, encoding: .utf8) ?? ""
            }

            let data = try JSONSerialization.data(withJSONObject: jsonObj, options: .prettyPrinted)

            return String(data: data, encoding: .utf8) ?? ""
        } catch {
            return ""
        }
    }
}
