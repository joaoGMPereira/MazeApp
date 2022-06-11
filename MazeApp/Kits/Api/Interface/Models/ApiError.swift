enum ApiError: Error {
    case notFound
    case unauthorized
    case badRequest
    case tooManyRequests
    case otherErrors
    case connectionFailure
    case cancelled
    case serverError
    case timeout
    case bodyNotFound
    case upgradeRequired
    case failedDependency
    case malformedRequest(_: String?)
    case decodeError(_: Error)
    case unknown(_: Error?)
}
