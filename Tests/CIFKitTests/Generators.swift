@testable import CIFKit
import Foundation
import SwiftCheck

extension Decimal: Arbitrary, RandomType {
    public static func randomInRange<G>(_ range: (Decimal, Decimal), gen: G) -> (Decimal, G) where G : RandomGeneneratorType {
        let (v, gen) = Double.randomInRange(
            (Double(truncating: range.0 as NSNumber), Double(truncating: range.1 as NSNumber)),
            gen: gen
        )
        
        return (Decimal(floatLiteral: v), gen)
    }
    
    public static var arbitrary: Gen<Decimal> {
        return Double.arbitrary.map { Decimal(floatLiteral: $0) }
    }
    
    
}

struct ArbitraryStringCIFValue: Arbitrary {
    let value: CIFValue
    
    /// Rather than generate arbitrary strings, we use a set of "naughty" strings.
    static var arbitrary: Gen<ArbitraryStringCIFValue> {
        return Gen<String>
            .fromElements(of: naughtyStrings)
            .map { CIFValue($0) }
            .map { ArbitraryStringCIFValue(value: $0) }
    }
}

struct ArbitraryNumberCIFValue: Arbitrary {
    let value: CIFValue

    /// Arbitrarily generating numbers is somewhat more complex.
    static var arbitrary: Gen<ArbitraryNumberCIFValue> {
        return Gen.compose { (c) in
            // Generate a value, e.g: 1.23456
            let value = c.generate(using: Decimal.arbitrary)
            
            // e.g. 0.00001
            let ulp = value.ulp
            
            // Note: ulp = unit in last (decimal) place
            let decimalPlaces = -1 * ulp.exponent
            
            let suMax = ulp * (pow(10.0, decimalPlaces) - 1)
            
            let su = c.generate(using: Gen<Decimal>.choose((0.0, suMax)))

            return CIFValue(
                Double(truncating: value as NSNumber),
                uncertainty: Double(truncating: su as NSNumber),
                roundingRule: 19)
        }.map { ArbitraryNumberCIFValue(value: $0) }
    }
}

