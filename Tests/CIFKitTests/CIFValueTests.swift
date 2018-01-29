import XCTest
import SwiftCheck
@testable import CIFKit


class CIFValueTests: XCTestCase {
    func testInitializers() {
        // Some text that is aggressive with combining codepoints.
        let text = """
            Ţ̩̦̦o̵͇̙̣͖͚ ͈̯͇̝̤i͔̳̞̱̲͎̲n̘v͚̗̪̻͠o͈̫k͙͚̘̟̭̰̞e̴̘͖͓͎̲ ț̗͖̬̥̫ḥ̘̰̹͈e̳͎̳̝ ̴͚̼̙̞ͅͅh́ị̡͇͔̫̜̙ͅv̡̖̗e̳̩̠̯̕-̜̮̠̰̻m҉i҉͈̝̝̼̹̯nd͇͔͘ͅ ͜re̗̝̮p̶̙͙͇̰̟̝̜ŗ̻̞̠e͓̠̮̥̻̪s̭͘e҉͎͚̙͚̦̻n̼͙̬̼ṱ̫̖̙̘̺͓i̷̘̞͎̘͍ͅn̲̝̙̙g͚̫̘ ̢͔͕c̛͔͙̦̤͙̠̫ḥ̷͖a̝͖̘͇̞o̙͇̹̘͕̬̘͜s̹͓.
            I̠̻͚̖̰̱n̨̳̘̰͇̮̻v̘͔o̬̝̖k̙̣̲i̬̰͚̕n͉͕̻̟͙ͅͅg̙̣̟̼̝͞ ̧͖t̰̫͍̣͚͕͎h̭̭e͕̦ ̣̬͉͍fe̜̼͜e͍̹̗̤͚l̢̠͔i̢̜̥̯n̲͔̖͈g̙̭͔̰̺͟ ̜̺̫͓̖͎ͅo͈͖͔f͓̦͍͈̬͕̙ ̥͚͙ch̖͔͎͓̘a͘o̳̭̲̜͎s̤̳̪.̲̤̫
            ̤̲͍͎W̞̘̻̱͕i͎͇̼̝͉̗̕t̤͉̘̥̩͟h͔͝ ̶̗͓̹̙͎o͕͈̮̯̜̗̝ṷt̻̞͇͍͓͕ ̦͎̭͉̖͟ò͍̣̜̖͓̳r̫̹̮̖̪̝̻͟d͏̮e̶̱̱̺r̨.͏̦̱̮̖͖̥
            ̙̱̱̭̜̭T̴͖h̺͓͈̠̳̕e ͝Ṇ̙ͅe̫̠͔̰͖z̤̣̀p҉͉̞̜e̫̜̞̮̩̭͠r̼͍̲̭͠dį̝̣̣̞̗͚̪a̠͕n̯̝̱̺͓̕ ̣͉̹̯͓̹͟h̳͔̝̗̳i̦̜̪v̗̥͉͎̼̞ͅę̖-̞͈̙m̤͚͖̥̳i̵̹n͇̹d̜̰͕̘͔̖̣ ̢̥̙o̗͉̘̝͍͕͘ͅf̬ ̛͙ch͉̻̱̬a͏͚̰o̩͇̻̖s̙̣͕͚̟̼̤.͚͜ͅ ҉̘̻̠̝͎̻Za̢̬͍͓̘̙lg̞̻̤͓̗̦̬̕ọ̲͓̯̖̣͙.͓͍̳͚́
            ̣͇H͜e̹̺͈ ̧̰̺̟̭w̗̮͓ḫ͓̗͜o͉̦̠͜ ̪̬̲̙͕W̠̜̪̹̱ͅa̗̣̩̲i̱̯̙͙̱͖̜t̸͉̪̥s͚͕͉̼͍̩̲ ̱̮̰͕B̶͙͚̭e̫̮̞͝h̰̦͔̦͎̩i̦̟̩͟nd̶̝̲ ̦̳̟̗̗͎̳͢T̡̜͇̲͚̝h̢̗͈̳̲͕̺e̯̫̯̥͖͖ ͙̯͍̥̩̤Wa̗̠̯̹̥͕ļ͍̲̮̣l͓̠͎̮̺̜.̣̫͍̤͟ͅ
            ̨Z̟̼̟̖̲̘͖͝A̸̱̠̪L̴̯͇͖̪͈̖͖Ǵ̭Ơ̫͇̜̮͖!͏̗̦̭̻͕
        """
        
        let number      = 6.022140857
        let uncertainty = 74e-9
        
        // We use rounding rule 99 here, as with the default (19) the number
        // and uncertainty will be adjusted (19 < 74).
        let v1 = try! CIFValueObject(number, uncertainty: uncertainty, roundingRule: 99)
        
        XCTAssert(abs(number - v1.number!) < 0.01)
        XCTAssert(abs(uncertainty - v1.uncertainty!) < 0.01)
        
        let v2 = try! CIFValueObject(text)
        
        XCTAssertEqual(v2.text!, text)
    }
    
    func testNumbers() {
        
    }
    
    static var allTests = [
        ("testStrings", testInitializers),
    ]
}

