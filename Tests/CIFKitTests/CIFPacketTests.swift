import XCTest
import SwiftCheck
@testable import CIFKit


class CIFPacketTests: XCTestCase {
    func testPacketInitializer() {
        let names = ["_lorem", "_ipsum", "_dolor", "_sit.amet"]
        let packet = try! CIFPacketObject(names: names)
        
        XCTAssertEqual(packet.names, names)
    }
    
    func testPacketSubscript() {
        do {
            let packet = try CIFPacketObject(names: [])
            try packet.set("_lorem", try CIFValueObject("foo bar baz"))
            XCTAssertEqual("foo bar baz", try packet.get("_lorem").text)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    static var allTests = [
        ("testPacketInitializer", testPacketInitializer),
    ]
}


