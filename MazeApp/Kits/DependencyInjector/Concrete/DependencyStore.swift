import Foundation

final class DependencyStore: DependencyStoring {
    private let lock: ThreadRecursiveLocking

    private var dependencies = NSMapTable<NSNumber, AnyObject>(
        keyOptions: .strongMemory,
        valueOptions: .weakMemory
    )

    private var factories = [Int: DependencyFactory]()

    init(lock: ThreadRecursiveLocking) {
        self.lock = lock
    }

    func getKey<T>(for metaType: T.Type) -> Int {
        ObjectIdentifier(metaType).hashValue
    }

    private func executeFactory(for key: Int) -> AnyObject? {
        guard let factory: DependencyFactory = factories[key] else { return nil }
        return factory()
    }

    private func createDependency<T>(_ metaType: T.Type, for key: Int) -> T? {
        let object = executeFactory(for: key)
        guard let dependency = object as? T else { return nil }
        dependencies.setObject(object, forKey: NSNumber(value: key))
        return dependency
    }

    func get<T>(_ metaType: T.Type) -> T? {
        lock.lock()
        defer { lock.unlock() }
        let key = getKey(for: metaType)
        guard let dependency = dependencies.object(forKey: NSNumber(value: key)) as? T else {
            return createDependency(metaType, for: key)
        }
        return dependency
    }

    func add<T>(_ factory: @escaping DependencyFactory, for metaType: T.Type) {
        lock.lock()
        defer { lock.unlock() }
        let key = getKey(for: metaType)
        factories[key] = factory
    }
}
