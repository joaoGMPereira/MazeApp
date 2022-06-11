import Foundation

extension UserDefaults {
    func getObject<T: Decodable>(key: String) -> T? {
        guard let data = data(forKey: key) else { return nil }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch { print(error); return nil }
    }

    func setObject<T: Encodable>(_ value: T, key: String) {
        let data = try? JSONEncoder().encode(value)
        set(data, forKey: key)
    }
}
