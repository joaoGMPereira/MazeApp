import Foundation

final class DependencyInjector: DependencyInjecting {
    private let store: DependencyStoring
    private let failureHandler: FailureHandler

    init(store: DependencyStoring,
         failureHandler: @escaping FailureHandler = { message in preconditionFailure(message) }) {
        self.store = store
        self.failureHandler = failureHandler
    }

    func register<Dependency>(_ factory: @escaping DependencyFactory, for metaType: Dependency.Type) {
        store.add(factory, for: metaType)
    }

    func safelyResolve<Dependency>(_ metaType: Dependency.Type) -> Dependency? {
        store.get(metaType)
    }

    func resolve<Dependency>(_ metaType: Dependency.Type) -> Dependency {
        guard let dependency = safelyResolve(metaType) else {
            failureHandler(.attempt(metaType))
        }
        return dependency
    }
}
