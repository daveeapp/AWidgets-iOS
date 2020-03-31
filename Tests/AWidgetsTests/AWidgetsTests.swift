import XCTest
@testable import AWidgets

final class AWidgetsTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(AWidgets().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
