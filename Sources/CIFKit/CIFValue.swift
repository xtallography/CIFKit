//
//  CIFValue.swift
//  CIFKitPackageDescription
//
//  Created by Dylan Lukes on 1/23/18.
//

import Foundation
import CCIF
import CCIF.Internal

public enum CIFValueKind: Int {
    case string = 0
    case number = 1
    case list = 2
    case table = 3
    case notApplicable = 4
    case unknown = 5
}

public enum CIFValueQuoteStyle: Int {
    case unquoted = 0
    case quoted = 1
}

/// The parent protocol for both concrete CIFValues, and un-owned CIFValueRefs.
public protocol CIFValueProtocol: RawRepresentable {
    var rawValue: CCIFValuePointer { get set }
    
    func clean() throws
}

public extension CIFValueProtocol {
    /// Resets the value object to an instance of the unknown value (?),
    /// releasing any owned resources.
    public func clean() throws {
        rawValue.clean()
    }
    
    /// Creates an independent value object with identical contents.
    public func clone() throws -> CIFValueObject {
        return CIFValueObject(rawValue: try rawValue.clone())
    }

    public func clone(onto target: CIFValueObject) throws -> Void {
        try rawValue.clone(onto: target.rawValue)
    }
}

/// A non-owning reference to a CIF value, such as a value in an aggregate
/// value (list, table, packet, etc). The underlying value is not released when
/// this object is freed.
public struct CIFValueReference: CIFValueProtocol {
    public var rawValue: CCIFValuePointer
    
    public init(rawValue: CCIFValuePointer) {
        self.rawValue = rawValue
    }
}

/// An independent CIF value, that is not a part of any aggregate value or
/// packet. Unlike most CIF objects (other than CIFPacket), CIFValue is not a
/// handle, and owns its own resources.
public class CIFValueObject: CIFValueProtocol {
    public var rawValue: CCIFValuePointer
    
    public required init(rawValue: CCIFValuePointer) {
        self.rawValue = rawValue
    }
    
    deinit {
        rawValue.free()
    }
}
