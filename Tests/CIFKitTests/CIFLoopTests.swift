import XCTest
import SwiftCheck
@testable import CIFKit


class CIFLoopTests: XCTestCase {
    func testLoops() {
        do {
            let cif = CIF()
            
            try cif.create(block: "_foo") { block in
                let names = ["_x", "_y", "_z"]
                
                try block.create(loop: "_bar", names: names) { loop in
                    // TODO: handle add packet
                    let p = try CIFPacket(names: names)
                    
                    p["_x"] = .number(3.14, uncertainty: 0.01, roundingRule: 19) as CIFValue
                    p["_y"] = 0.0 as CIFValue
                    p["_z"] = 0.0 as CIFValue
                    
                    try loop.append(packet: p)
                }
            }
            
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    static var allTests = [
        ("testLoops", testLoops)
    ]
}

