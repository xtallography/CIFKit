import XCTest
import SwiftCheck
@testable import CIFKit

class CIFPacketTests: XCTestCase {
    func testPacketInitializer() {
        let names = ["_lorem", "_ipsum", "_dolor", "_sit.amet"]
        let packet = try! CIFPacket(names: names)
        
        XCTAssertEqual(packet.names, names)
    }
    
    func testPacketSubscript() {
        do {
            let packet = try CIFPacket(names: [])
            packet["_lorem"] = "foo bar baz" as CIFValue
            XCTAssertEqual("foo bar baz", packet["_lorem"]?.text)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testPacketLiteral() {
        let _: CIFPacket = [
            "_foo": 0.05,
            "_bar": "lorem ipsum"
        ]
    }
    
    static var allTests = [
        ("testPacketInitializer", testPacketInitializer),
        ("testPacketSubscript", testPacketSubscript)
    ]
}
