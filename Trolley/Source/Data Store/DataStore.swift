import Foundation

struct DataStore {
    
    func save<T: Codable>(_ item: T) {
        let encoded = try! JSONEncoder().encode(item)
        UserDefaults.standard.set(encoded, forKey: String(describing: T.self))
    }
    
    func fetch<T: Codable>(_ type: T.Type) -> T? {
        guard let raw = UserDefaults.standard.value(forKey: String(describing: T.self)) as? Data
            else { return nil }
        return try? JSONDecoder().decode(T.self, from: raw)
    }
    
    @discardableResult
    func removeAll<T: Codable>(_ type: T.Type) -> T? {
        let item = fetch(T.self)
        UserDefaults.standard.set(nil, forKey: String(describing: T.self))
        return item
    }
    
}
