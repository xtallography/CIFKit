import Foundation
import CCIF.Shims

/// Represents a valid CIF item or category name, and provides
/// some utilities for working with them. It is required to use this
/// type is required for non-throwing subscripts.
///
/// - Note: CIFName is ExpressibleByStringLiteral, but will trigger an
///         assertion failure if the name is not valid.
public struct CIFName: ExpressibleByStringLiteral {
    public typealias StringLiteralType = String
    
    let name: String
    public init(stringLiteral name: String) {
        // TODO: actually perform validation here.
        self.name = name
    }
    
    public init(_ name: String) throws {
        self.name = name
    }
}
