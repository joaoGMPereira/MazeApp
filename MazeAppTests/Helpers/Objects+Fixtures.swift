extension String {
    static var anyValue: String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let chars = (0..<20).compactMap { _ in
            letters.randomElement()
        }
        return String(chars)
    }
}

extension Int {
    static var anyValue: Int {
        let letters = "0123456789"
        let chars = (0..<20).compactMap { _ in
            letters.randomElement()
        }
        return Int(String(chars)) ?? .zero
    }
}
