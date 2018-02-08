//
//  CIFValue.swift
//  CIFKit
//
//  Created by Dylan Lukes on 1/23/18.
//

import CCIF
import Foundation

// MARK: - All CIF Values

/// The parent protocol for both concrete CIFValues, and un-owned CIFValueRefs.
public protocol CIFValueProtocol {
    var cPtr: CCIFValuePointer { get }
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
        cPtr.clean()
    }

    /// Creates an independent value object with identical contents.
    public func clone() throws -> CIFValueObject {
        return CIFValueObject(cPtr: try cPtr.clone())
    }

    public func clone(onto target: CIFValueObject) throws {
        try cPtr.clone(onto: target.cPtr)
    }

    // MARK: - (Re)initialization

    public func reinitialize(_ kind: CIFValueKind) throws {
        try cPtr.reinitialize(kind: cif_kind_tp(UInt32(kind.rawValue)))
    }

    public func reinitialize(_ string: String) throws {
        try cPtr.reinitialize(string)
    }

    public func reinitialize(_ value: Double, uncertainty: Double, scale: Int, maxLeadingZeroes: Int) throws {
        try cPtr.reinitialize(value,
                              uncertainty: uncertainty,
                              scale: scale,
                              maxLeadingZeroes: maxLeadingZeroes)
    }

    public func reinitialize(_ value: Double, uncertainty: Double, roundingRule: Int = 19) throws {
        try cPtr.reinitialize(value,
                              uncertainty: uncertainty,
                              roundingRule: roundingRule)
    }

    // MARK: - Kind and Quote Status

    public var kind: CIFValueKind {
        return CIFValueKind(rawValue: Int(cPtr.getKind().rawValue))!
    }

    public var quoteStyle: CIFValueQuoteStyle {
        return CIFValueQuoteStyle(rawValue: Int(cPtr.getQuoting().rawValue))!
    }

    // TODO: set quoting

    // MARK: - Optional Value Accessors

    /// The numerical value of this value, or nil if it does not represent a number.
    public var number: Double? {
        return try? cPtr.getNumber()
    }

    /// The standard uncertainty of this value, or nil if it does not represent a number.
    public var uncertainty: Double? {
        return try? cPtr.getUncertainty()
    }

    /// The text of this value, or nil if it is a value that is not representable as text (i.e. list or table).
    public var text: String? {
        return try? cPtr.getText()
    }

    /// The number of elements in an aggregate value, or nil if this is not an aggregate value.
    public var count: Int? {
        return try? cPtr.getElementCount()
    }

    /// The elements in a list value, or nil if this is not a list.
    public var list: [CIFValueReference]? {
        guard case .list = kind, let count = count else { return nil }

        return (0 ..< count)
            .flatMap { try? cPtr.get(at: $0) }
            .map(CIFValueReference.init)
    }

    /// The keys in a table value, or nil if this is not a table.
    public var keys: [String]? {
        return try? cPtr.getItemKeys()
    }

    /// The key-value items in a table value, or nil if this is not a table.
    public var table: [String: CIFValueReference]? {
        guard case .table = kind, let keys = keys else { return nil }

        return [String: CIFValueReference](uniqueKeysWithValues: keys
            .flatMap { try? ($0, cPtr.get(key: $0)) }
            .map { ($0.0, CIFValueReference($0.1)) }
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
    var _cPtr: CCIFValuePointer
    public var cPtr: CCIFValuePointer { return _cPtr }

    internal init(_ cPtr: CCIFValuePointer) {
        _cPtr = cPtr
    }
}

extension CIFValueReference: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch kind {
        case .string:
            return "CIFValueReference(\"\(text!)\")"
        case .number:
            return "CIFValueReference(\(number!))"
        case .list:
            return "CIFValueReference([\(list!)])"
        case .table:
            return "CIFValueReference({\(table!)})"
        case .notApplicable:
            return "CIFValueReference(.)"
        case .unknown:
            return "CIFValueReference(?)"
        }
    }
}

// MARK: - Independent CIF Value Objects

/// An independent CIF value, that is not a part of any aggregate value or
/// packet. Unlike most CIF objects (other than CIFPacket), CIFValue is not a
/// handle, and owns its own resources.
public class CIFValueObject: CIFValueProtocol {
    internal var _cPtr: CCIFValuePointer
    public var cPtr: CCIFValuePointer { return _cPtr }

    internal init(cPtr: CCIFValuePointer) {
        _cPtr = cPtr
    }

    public init(_ kind: CIFValueKind) {
        // This can fail due to allocation issues, we choose to fail hard.
        _cPtr = try! CCIFValuePointer.create(kind: kind.cValue)
    }

    public convenience init(_ text: String) throws {
        self.init(.string)
        try cPtr.reinitialize(text)
    }

    public convenience init(_ value: Double, uncertainty: Double = 0.0, scale: Int, maxLeadingZeroes: Int) throws {
        self.init(.number)
        try cPtr.reinitialize(value, uncertainty: uncertainty, scale: scale, maxLeadingZeroes: maxLeadingZeroes)
    }

    public convenience init(_ value: Double, uncertainty: Double = 0.0, roundingRule: Int = 19) throws {
        self.init(.number)
        try cPtr.reinitialize(value, uncertainty: uncertainty, roundingRule: roundingRule)
    }

    public convenience init<CIFValue: CIFValueProtocol>(_ list: [CIFValue]) throws {
        self.init(.list)
        for element in list.reversed() {
            try cPtr.insert(at: 0, toCopyOf: element.cPtr)
        }
    }

    public convenience init<CIFValue: CIFValueProtocol>(_ table: [String: CIFValue]) throws {
        self.init(.table)
        for item in table {
            try cPtr.set(key: item.key, toCopyOf: item.value.cPtr)
        }
    }

    deinit {
        _cPtr.free()
    }
}

extension CIFValueObject: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch kind {
        case .string:
            return "CIFValueObject(\"\(text!)\")"
        case .number:
            return "CIFValueObject(\(number!))"
        case .list:
            return "CIFValueObject([\(list!)])"
        case .table:
            return "CIFValueObject({\(table!)})"
        case .notApplicable:
            return "CIFValueObject(.)"
        case .unknown:
            return "CIFValueObject(?)"
        }
    }
}
