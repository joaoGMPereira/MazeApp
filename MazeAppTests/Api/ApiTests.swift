import XCTest
@testable import MazeApp

class ApiTests: XCTestCase {
    
    func testMakeRequest_WhenInjectValidObject_ShouldResultSuccess() throws {
        let api = makeSut()
        let response = ApiResponseSpy()
        let urlSessionable = URLSessionableSpy()
        urlSessionable.data = response.data
        var parsedResponse: ApiResponseSpy?
        let expectation = expectation(description: "api parse Response")
        api.execute(endpoint: ApiEndpointExposableSpy.test, session: urlSessionable) {(result: Result<Success<ApiResponseSpy>, ApiError>) in
            switch result {
            case .success(let response):
                parsedResponse = response.model
                expectation.fulfill()
            case .failure(let error): print(error)
            }
        }
        
        wait(for: [expectation], timeout: 0.5)
        let urlRequest = try XCTUnwrap(api.makeRequest(with: ApiEndpointExposableSpy.test))
        XCTAssertEqual(urlSessionable.messages, [.dataTask(urlRequest)])
        XCTAssertEqual(parsedResponse, response)
    }
    
    func testMakeRequest_WhenInjectInvalidObject_ShouldResultError() throws {
        let api = makeSut()
        let urlSessionable = URLSessionableSpy()
        urlSessionable.data = Data()
        var errorResponse: ApiError?
        let expectation = expectation(description: "api fail to parse Response")
        api.execute(endpoint: ApiEndpointExposableSpy.test, session: urlSessionable) {(result: Result<Success<ApiResponseSpy>, ApiError>) in
            switch result {
            case .success: break
            case .failure(let error):
                errorResponse = error
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 0.5)
        let urlRequest = try XCTUnwrap(api.makeRequest(with: ApiEndpointExposableSpy.test))
        XCTAssertEqual(urlSessionable.messages, [.dataTask(urlRequest)])
        XCTAssertEqual(errorResponse?.rawValue, "decodeError")
    }
    
    func testMakeRequest_WhenInjectBadRequestError_ShouldResultError() throws {
        let api = makeSut()
        let urlSessionable = URLSessionableSpy()
        urlSessionable.error = ApiError.badRequest
        var errorResponse: ApiError?
        let expectation = expectation(description: "api fail to make request")
        api.execute(endpoint: ApiEndpointExposableSpy.test, session: urlSessionable) {(result: Result<Success<ApiResponseSpy>, ApiError>) in
            switch result {
            case .success: break
            case .failure(let error):
                errorResponse = error
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 0.5)
        let urlRequest = try XCTUnwrap(api.makeRequest(with: ApiEndpointExposableSpy.test))
        XCTAssertEqual(urlSessionable.messages, [.dataTask(urlRequest)])
        XCTAssertEqual(errorResponse, .badRequest)
    }
    
    func makeSut() -> Api {
        let sut = Api(dependencies: DependencyContainerMock())
        return sut
    }
}

enum ApiEndpointExposableSpy {
    case test
}

extension ApiEndpointExposableSpy: ApiEndpointExposable {
    var path: String {
        "test"
    }
    
    var method: HTTPMethod {
        .get
    }
}

extension ApiError: AutoEquatable {
    
    var rawValue: String {
        switch self {
        case .unauthorized:
            return "unauthorized"
        case .badRequest:
            return "badRequest"
        case .redirectionNotAllowed:
            return "redirectionNotAllowed"
        case .otherErrors:
            return "otherErrors"
        case .connectionFailure:
            return "connectionFailure"
        case .cancelled:
            return "cancelled"
        case .serverError:
            return "serverError"
        case .bodyNotFound:
            return "bodyNotFound"
        case .malformedRequest:
            return "ApiError.malformedRequest"
        case .decodeError:
            return "decodeError"
        case .unknown:
            return "unknown"
        }
    }
}

struct ApiResponseSpy: Codable, AutoEquatable {
    let test: String
    init(test: String = .anyValue) {
        self.test = test
    }
    var data: Data? {
        return try? JSONEncoder().encode(self)
    }
}
