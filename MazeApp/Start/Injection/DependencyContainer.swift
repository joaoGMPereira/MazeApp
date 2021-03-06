import Foundation

typealias AppDependencies =
    // MARK: Dispatches
    HasMainQueue &
    HasGlobalQueue &
    // MARK: API
    HasURLSessionable &
    HasApi &
    // MARK: Storage
    HasStorageable &
    // MARK: Tab
    HasTabControlling


final class DependencyContainer: AppDependencies {
    private let resolver: DependencyResolving
    
    lazy var mainQueue: DispatchQueue = DispatchQueue.main
    lazy var globalQueue: DispatchQueue = DispatchQueue.global(qos: .background)
    lazy var session: URLSessionable = resolver.resolve()
    lazy var api: ApiProtocol = resolver.resolve()
    lazy var storage: Storageable = resolver.resolve()
    lazy var tabBarController: TabControlling = resolver.resolve()
    
    init(resolver: DependencyResolving = AppResolver.shared) {
        self.resolver = resolver
    }
}
