import XCTest
@testable import FunctionalNetworking

final class DebouncerTests: XCTestCase {

  func testValueLinearOneRun() {
    let result = Debounce.linear(10).run()
    XCTAssertEqual(10, result.value)
    XCTAssertEqual(10, result.run().value)
  }

  func testValueLinearExpOneRun() {
    let result = Debounce.exponential(10).run()
    XCTAssertEqual(20, result.value)
    XCTAssertEqual(40, result.run().value)
  }
}
