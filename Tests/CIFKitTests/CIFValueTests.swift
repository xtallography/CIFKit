import XCTest
import SwiftCheck
@testable import CIFKit

let ε = Double.ulpOfOne

class CIFValueTests: XCTestCase {
    func testStrings() {
        property("string values behave") <- forAll { (str: ArbitraryStringCIFValue) in
            return str.value.text != nil
        }
    }
    
    func testNumbers() {
        property("numeric values behave") <- forAll { (num: ArbitraryNumberCIFValue) in
            return (num.value.number != nil && num.value.uncertainty != nil)
        }
        
        property("numeric values can be coerced to text") <- forAll { (num: ArbitraryNumberCIFValue) in
            return num.value.text != nil
        }
        
        property("numeric values are preserved through text") <- forAll { (num: ArbitraryNumberCIFValue) in
            let (v1, su1) = (num.value.number!, num.value.uncertainty!)
            
            let num2 = try! CIFValueObject(num.value.text!)
            let (v2, su2) = (num2.number!, num2.uncertainty!)
            
            return abs(v1 - v2) < ε && abs(su1 - su2) < ε
        }
    }
    
    func testLists() {
        property("lists of numbers behave") <- forAll { (list: [ArbitraryNumberCIFValue]) in
            return try! CIFValueObject(list.map { $0.value }).count != nil
        }
        
        property("lists of strings behave") <- forAll { (list: [ArbitraryStringCIFValue]) in
            return try! CIFValueObject(list.map { $0.value }).count != nil
        }
    }
    
    static var allTests = [
        ("testStrings", testStrings),
    ]
}

