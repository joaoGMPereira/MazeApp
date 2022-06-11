extension String {
    static func duplicated(_ argument: Any) -> String { "🚨\nAttempted to resolve \(argument) twice!\n"
    }
    static func attempt(_ argument: Any) -> String { "🚨\nAttempted to resolve \(argument), but there's nothing registered for this type.\n"
    }
    static func unresolved(_ argument: Any) -> String { "🚨\nAttempted to use \(argument) without resolving it first!\n"
    }
    static func unexpected(_ firstArgument: Any,
                           _ secondArgument: Any) -> String { "🚨\nAttempted to inject \(firstArgument) for \(secondArgument), but there's no matching variable.\n"
    }
}
