enum HTTPStatusCode: Int, Comparable {
    static func < (lhs: HTTPStatusCode, rhs: HTTPStatusCode) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    // MARK: 100 Informational
    case `continue` = 100
    case processing
    // MARK: 200 Success
    case ok = 200
    // MARK: 300 Redirection
    case redirection = 300
    // MARK: 400 Client Error
    case badRequest = 400
    // MARK: 500 Server Error
    case internalServerError = 500
    case notValidStatus = 600
}

