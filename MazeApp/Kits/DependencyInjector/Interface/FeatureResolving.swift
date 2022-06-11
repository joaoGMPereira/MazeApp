protocol DependencyInjectable {
    func inject<Dependency>(_ dependency: Dependency, for metaType: Dependency.Type, failureHandler: @escaping FailureHandler)
}

extension DependencyInjectable {
    func inject<Dependency>(_ dependency: Dependency,
                            for metaType: Dependency.Type,
                            failureHandler: @escaping FailureHandler = { preconditionFailure($0) }) {
        guard let instance = Mirror(reflecting: self)
                                .children
                                .first(where: { $0.value is Injected<Dependency> })?
                                .value as? Resolvable else {
            failureHandler(.unexpected(dependency, metaType))
        }
        instance.resolve(with: dependency)
    }

    func inject<Dependency>(_ dependency: Dependency, failureHandler: @escaping FailureHandler = { preconditionFailure($0) }) {
        inject(dependency, for: Dependency.self, failureHandler: failureHandler)
    }
}

protocol ChildResolver: DependencyResolving {
    var parentResolver: DependencyResolving { get }
}

extension ChildResolver {
    func resolve<Dependency>(_ metaType: Dependency.Type) -> Dependency {
        parentResolver.resolve(metaType)
    }

    func safelyResolve<Dependency>(_ metaType: Dependency.Type) -> Dependency? {
        parentResolver.safelyResolve(metaType)
    }
}

protocol FeatureResolving: DependencyInjectable, ChildResolver {}
