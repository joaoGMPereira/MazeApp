import XCTest

extension Optional {
    func safe(_ file: StaticString = #file, line: UInt = #line) throws -> Wrapped {
        guard let safeUnwraped = self else {
            XCTFail("Could not unwrap \(type(of: self))", file: file, line: line)
            throw XCTestError.couldNotUnwrap
        }
        return safeUnwraped
    }
}

enum XCTestError: Error {
    case couldNotUnwrap
    var localizedDescription: String {
        "Could not unwrap value"
    }
}
