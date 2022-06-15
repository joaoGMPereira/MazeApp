import Foundation
@testable import MazeApp

final class DependencyContainerMock: AppDependencies {
    lazy var api: ApiProtocol = resolve(default: ApiProtocolSpy())
    lazy var globalQueue: DispatchQueue = DispatchQueue.global(qos: .background)
    lazy var mainQueue: DispatchQueue = DispatchQueue(label: "AppTests")
    lazy var storage: Storageable = resolve(default: StorageableSpy())
    lazy var tabBarController: TabControlling = resolve(default: TabControllingSpy())
    lazy var session: URLSessionable = resolve(default: URLSessionableSpy())
    
    

    private let dependencies: [Any]

    init(_ dependencies: Any...) {
        self.dependencies = dependencies
    }
}

extension DependencyContainerMock {
    func resolve<T>() -> T {
        let resolved = dependencies.compactMap { $0 as? T }

        switch resolved.first {
        case .none:
            fatalError("DependencyContainerMock could not resolve dependency: \(T.self)\n")
        case .some where resolved.count > 1:
            fatalError("DependencyContainerMock resolved mutiple dependencies for: \(T.self)\n")
        case .some(let mock):
            return mock
        }
    }

    func resolve<T>(default: T) -> T {
        guard let mock = dependencies.first(where: { $0 is T }) as? T else {
            return `default`
        }
        return mock
    }
}
