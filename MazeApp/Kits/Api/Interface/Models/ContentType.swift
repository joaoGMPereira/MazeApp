enum ContentType {
    case applicationJson
    
    var rawValue: String {
        switch self {
        case .applicationJson:
            return "application/json"
        }
    }
}

