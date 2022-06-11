typealias DependencyFactory = () -> AnyObject
typealias DependencyFactoryResolver = (DependencyResolving) -> AnyObject

protocol DependencyResolving {
    func resolve<Dependency>(_ metaType: Dependency.Type) -> Dependency
    func safelyResolve<Dependency>(_ metaType: Dependency.Type) -> Dependency?
}

extension DependencyResolving {
    func resolve<Dependency>() -> Dependency {
        resolve(Dependency.self)
    }
}

protocol DependencyRegistering {
    func register<Dependency>(_ factory: @escaping DependencyFactory, for metaType: Dependency.Type)
}

protocol DependencyInjecting: DependencyRegistering, DependencyResolving {}

extension DependencyInjecting {
    func register<Dependency>(_ factory: @escaping DependencyFactoryResolver, for metaType: Dependency.Type) {
        let factory: DependencyFactory = { factory(self) }
        register(factory, for: metaType)
    }
}
