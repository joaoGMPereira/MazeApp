protocol HasStorageable {
    var storage: Storageable { get }
}
protocol StorageKeyable {
    var rawValue: String { get }
    var identifiable: String { get }
}

protocol Storageable {
    func get<T: Decodable>(key: StorageKeyable) -> T?
    func getAll<T: Decodable>(identifiable: String, completion: (([T]) -> Void)?)
    func set<T: Encodable>(_ value: T, key: StorageKeyable)
    func clearValue(key: StorageKeyable)
}
