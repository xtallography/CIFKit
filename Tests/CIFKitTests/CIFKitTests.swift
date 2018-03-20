import XCTest
@testable import CIFKit

class CIFKitTests: XCTestCase {
    func testExample() {
        do {
            let c = CIF()
            try c.create(block: "_foo")
            try c.with(block: "_foo") {
                XCTAssert($0 != nil)
            }
            
            try c.with(block: "_bar") {
                XCTAssert($0 == nil)
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
