import Foundation

enum StorageKey: StorageKeyable {
    case favorite(_ key: String)
    
    var rawValue: String {
        switch self {
        case let .favorite(key):
            return "\(identifiable)\(key)"
        }
    }
    
    var identifiable: String {
        switch self {
        case .favorite:
            return "favorite_"
        }
    }
}

final class Storage: Storageable {
    typealias Dependencies = HasMainQueue & HasGlobalQueue
    private let userDefaults = UserDefaults.standard
    let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: Get Functions
    func get<T>(key: StorageKeyable) -> T? where T : Decodable {
        userDefaults.getObject(key: key.rawValue)
    }
    
    func getAll<T>(identifiable: String, completion: (([T]) -> Void)?) where T : Decodable {
        dependencies.globalQueue.async { [weak self] in
            guard let self = self else { return }
            print(self.userDefaults.dictionaryRepresentation().keys)
            let keys = self.userDefaults.dictionaryRepresentation().keys.filter { $0.contains(identifiable) }
            let objects = keys.compactMap { name -> T? in
                if let object: T = self.userDefaults.getObject(key: name)  {
                    return object
                }
                return nil
            }
            self.dependencies.mainQueue.async {
                completion?(objects)
            }
        }
        
    }
    
    // MARK: Set Functions
    func set<T>(_ value: T, key: StorageKeyable) where T : Encodable {
        userDefaults.setObject(value, key: key.rawValue)
    }
    
    // MARK: Clear Functions
    func clearValue(key: StorageKeyable) {
        userDefaults.removeObject(forKey: key.rawValue)
    }
}
