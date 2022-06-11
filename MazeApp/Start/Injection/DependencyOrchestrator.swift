import Foundation

final class DependencyOrchestrator: DependencyOrchestrating {
    private let injector: DependencyInjecting
    
    init(injector: DependencyInjecting = InjectorFactory.make()) {
        self.injector = injector
        registerAppDependencies()
    }
    
    private func registerAppDependencies() {
        registerWrappers()
    }
    private func registerWrappers() {
        injector.register({
            URLSession(configuration: .default)
        }, for: URLSessionable.self)
        injector.register({
            Api()
        }, for: Apiable.self)
        injector.register({
            Storage(dependencies: DependencyContainer())
        }, for: Storageable.self)
        injector.register({
            TabController.start()
        }, for: TabControlling.self)
    }
    
    func start() {
        AppResolver.shared.inject(injector as DependencyResolving)
    }
}
