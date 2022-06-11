typealias FailureHandler = (String) -> Never

protocol Resolvable {
    func resolve(with instance: Any)
}

@propertyWrapper
final class Injected<Dependency>: Resolvable {
    let failureHandler: FailureHandler

    var resolvedValue: Dependency?
    var wrappedValue: Dependency {
        guard let resolvedValue = resolvedValue else {
            failureHandler("Attempted to resolve \(metaType), but there's nothing registered for this type.")
        }
        return resolvedValue
    }

    private var isFirstTimeBeingResolved: Bool {
        resolvedValue == nil
    }

    private lazy var metaType = type(of: self)

    init(resolvedValue: Dependency?,
                failureHandler: @escaping FailureHandler = { message in preconditionFailure(message) }) {
        self.resolvedValue = resolvedValue
        self.failureHandler = failureHandler
    }

    convenience init() {
        self.init(resolvedValue: nil)
    }

    func resolve(with instance: Any) {
        guard isFirstTimeBeingResolved else {
            failureHandler(.duplicated(metaType))
        }
        guard let value = instance as? Dependency else {
            failureHandler(.attempt(metaType))
        }
        resolvedValue = value
    }
}

