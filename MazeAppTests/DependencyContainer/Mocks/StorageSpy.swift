@testable import MazeApp


class StorageableSpy: Storageable {

    // MARK: - Get<T: Decodable>
    private(set) var getKeyCallsCount = 0
    private(set) var getKeyReceivedInvocations: [StorageKeyable] = []
    var getKeyReturnValue: Any?

    func get<T: Decodable>(key: StorageKeyable) -> T? {
        getKeyCallsCount += 1
        getKeyReceivedInvocations.append(key)
        return getKeyReturnValue as? T
    }

    // MARK: - GetAll<T: Decodable>
    private(set) var getAllIdentifiableCompletionCallsCount = 0
    private(set) var getAllIdentifiableCompletionReceivedInvocations: [(identifiable: String, completion: (([Any]) -> Void)?)] = []

    func getAll<T: Decodable>(identifiable: String, completion: (([T]) -> Void)?) {
        getAllIdentifiableCompletionCallsCount += 1
        let keys = setKeyReceivedInvocations.map{$0.key}.filter { $0.rawValue.contains(identifiable) }
        let objects = keys.compactMap({ key -> T? in
            let object = self.setKeyReceivedInvocations.first(where: {
                return $0.key.rawValue == key.rawValue
            })
            return object?.value as? T
        })
        
        completion?(objects)
    }

    // MARK: - Set<T: Encodable>
    private(set) var setKeyCallsCount = 0
    private(set) var setKeyReceivedInvocations: [(value: Any, key: StorageKeyable)] = []

    func set<T: Encodable>(_ value: T, key: StorageKeyable) {
        setKeyCallsCount += 1
        setKeyReceivedInvocations.append((value: value, key: key))
    }

    // MARK: - ClearValue
    private(set) var clearValueKeyCallsCount = 0
    private(set) var clearValueKeyReceivedInvocations: [StorageKeyable] = []

    func clearValue(key: StorageKeyable) {
        clearValueKeyCallsCount += 1
        clearValueKeyReceivedInvocations.append(key)
    }
}
