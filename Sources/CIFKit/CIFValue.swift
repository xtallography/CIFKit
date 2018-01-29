//
//  CIFValue.swift
//  CIFKitPackageDescription
//
//  Created by Dylan Lukes on 1/23/18.
//

import Foundation
import CCIF
import CCIF.Internal

// MARK: - All CIF Values

/// The parent protocol for both concrete CIFValues, and un-owned CIFValueRefs.
public protocol CIFValueProtocol: RawRepresentable {
    var rawValue: CCIFValuePointer { get set }
}

public enum CIFValueKind: Int {
    case string = 0
    case number = 1
    case list = 2
    case table = 3
    case notApplicable = 4
    case unknown = 5
    
    internal var cValue: cif_kind_tp {
        return cif_kind_tp(UInt32(rawValue))
    }
}

public enum CIFValueQuoteStyle: Int {
    case unquoted = 0
    case quoted = 1
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
    
    // MARK: - (Re)initialization
    
    public func reinitialize(_ kind: CIFValueKind) throws {
        try rawValue.reinitialize(kind: cif_kind_tp(UInt32(kind.rawValue)))
    }
    
    public func reinitialize(_ string: String) throws {
        try rawValue.reinitialize(string)
    }
    
    public func reinitialize(_ value: Double, uncertainty: Double, scale: Int, maxLeadingZeroes: Int) throws {
        try rawValue.reinitialize(value,
                                  uncertainty: uncertainty,
                                  scale: scale,
                                  maxLeadingZeroes: maxLeadingZeroes)
    }
    
    public func reinitialize(_ value: Double, uncertainty: Double, roundingRule: Int = 19) throws {
        try rawValue.reinitialize(value,
                                  uncertainty: uncertainty,
                                  roundingRule: roundingRule)
    }
    
    // MARK: - Kind and Quote Status
    
    public var kind: CIFValueKind {
        return CIFValueKind(rawValue: Int(rawValue.getKind().rawValue))!
    }
    
    public var quoteStyle: CIFValueQuoteStyle {
        return CIFValueQuoteStyle(rawValue: Int(rawValue.getQuoting().rawValue))!
    }
    
    // TODO: set quoting
    
    // MARK: - Optional Value Accessors
    
    /// The numerical value of this value, or nil if it does not represent a number.
    public var number: Double? {
        return try? rawValue.getNumber()
    }
    
    /// The standard uncertainty of this value, or nil if it does not represent a number.
    public var uncertainty: Double? {
        return try? rawValue.getUncertainty()
    }
    
    /// The text of this value, or nil if it is a value that is not representable as text (i.e. list or table).
    public var text: String? {
        return try? rawValue.getText()
    }
    
    
    /// The number of elements in an aggregate value, or nil if this is not an aggregate value.
    public var count: Int? {
        return try? rawValue.getElementCount()
    }
    
    /// The elements in a list value, or nil if this is not a list.
    public var list: [CIFValueReference]? {
        guard case .list = kind, let count = count else { return nil }
        
        return (0..<count)
            .flatMap { try? rawValue.get(at: $0) }
            .map { CIFValueReference(rawValue: $0) }
    }
    
    /// The keys in a table value, or nil if this is not a table.
    public var keys: [String]? {
        return try? rawValue.getItemKeys()
    }
    
    /// The key-value items in a table value, or nil if this is not a table.
    public var table: [String:CIFValueReference]? {
        guard case .table = kind, let keys = keys else { return nil }
        
        return [String:CIFValueReference](uniqueKeysWithValues: keys
            .flatMap { try? ($0, rawValue.get(key: $0)) }
            .map { ($0.0, CIFValueReference(rawValue: $0.1)) }
        )
    }
}

// MARK: - Dependent CIF Value References

/// A non-owning reference to a CIF value, such as a value in an aggregate
/// value (list, table, packet, etc). The underlying value is not released when
/// this object is freed.
///
/// These can not be created except by wrapping an existing raw `cif_value_tp*`.
public struct CIFValueReference: CIFValueProtocol {
    public var rawValue: CCIFValuePointer
    
    public init(rawValue: CCIFValuePointer) {
        self.rawValue = rawValue
    }
}

// MARK: - Independent CIF Value Objects

/// An independent CIF value, that is not a part of any aggregate value or
/// packet. Unlike most CIF objects (other than CIFPacket), CIFValue is not a
/// handle, and owns its own resources.
public class CIFValueObject: CIFValueProtocol {
    public var rawValue: CCIFValuePointer
    
    public required init(rawValue: CCIFValuePointer) {
        self.rawValue = rawValue
    }
    
    public init(_ kind: CIFValueKind) {
        // This can fail due to allocation issues, we choose to fail hard.
        let rawValue = try! CCIFValuePointer.create(kind: kind.cValue)
        self.rawValue = rawValue
    }
    
    public convenience init(_ text: String) throws {
        self.init(.string)
        try self.rawValue.reinitialize(text)
    }
    
    public convenience init(_ value: Double, uncertainty: Double = 0.0, roundingRule: Int = 19) throws {
        self.init(.number)
        try self.rawValue.reinitialize(value, uncertainty: uncertainty, roundingRule: roundingRule)
    }
    
    public convenience init<CIFValue: CIFValueProtocol>(_ list: [CIFValue]) throws {
        self.init(.list)
        for element in list.reversed() {
            try self.rawValue.insert(at: 0, toCopyOf: element.rawValue)
        }
    }
    
    public convenience init<CIFValue: CIFValueProtocol>(_ table: [String:CIFValue]) throws {
        self.init(.table)
        for item in table {
            try self.rawValue.set(key: item.key, toCopyOf: item.value.rawValue)
        }
    }
    
    deinit {
        rawValue.free()
    }
}
