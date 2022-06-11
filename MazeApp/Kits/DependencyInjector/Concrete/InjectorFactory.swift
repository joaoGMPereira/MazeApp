import Foundation

enum InjectorFactory {
    enum DependencyStoringStrategy {
        case standard(lock: ThreadRecursiveLockingStrategy)
        case custom(DependencyStoring)

        var store: DependencyStoring {
            switch self {
            case let .custom(store):
                return store
            case let .standard(lockStrategy):
                return DependencyStore(lock: lockStrategy.lock)
            }
        }
    }

    enum ThreadRecursiveLockingStrategy {
        case foundation
        case mutex
        case custom(ThreadRecursiveLocking)

        var lock: ThreadRecursiveLocking {
            switch self {
            case .foundation:
                return NSRecursiveLock()
            case .mutex:
                return MutexRecursiveLock()
            case .custom(let lock):
                return lock
            }
        }
    }

    static func make(
        withStore strategy: DependencyStoringStrategy = .standard(lock: .mutex),
        resolvingFailureHandler: @escaping FailureHandler = { message in preconditionFailure(message) }
    ) -> DependencyInjecting {
        DependencyInjector(store: strategy.store, failureHandler: resolvingFailureHandler)
    }

    static func make(
        withLock strategy: ThreadRecursiveLockingStrategy,
        resolvingFailureHandler: @escaping FailureHandler = { message in preconditionFailure(message) }
    ) -> DependencyInjecting {
        make(withStore: .standard(lock: strategy), resolvingFailureHandler: resolvingFailureHandler)
    }
}
