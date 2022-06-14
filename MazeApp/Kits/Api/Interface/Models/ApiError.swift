enum ApiError: Error {
    case unauthorized
    case badRequest
    case redirectionNotAllowed
    case otherErrors
    case connectionFailure
    case cancelled
    case serverError
    case bodyNotFound
    case malformedRequest(_: String?)
    case decodeError(_: Error)
    case unknown
}
