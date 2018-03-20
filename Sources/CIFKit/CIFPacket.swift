import Foundation

public protocol CIFPacketProtocol {
    var cPtr: CCIFPacketPointer { get }
}

extension CIFPacketProtocol {
    public var names: [String] {
        return try! cPtr.getNames()
    }
    
    public func get(_ name: String) throws -> CIFValueReference? {
        return CIFValueReference(try cPtr.get(name))
    }
    
    /// Sets the value associated with the given name.
    /// - Note: nil corresponds to the unknown value.
    public func set(_ name: String, _ value: CIFValueProtocol?) throws {
        try cPtr.set(name, value?.cPtr)
    }
    
    /// The subscript is analogous to get/set, but fails hard on errors.
    /// This is useful as a convenience, but get/set is preferable when
    /// handling user-provided keys.
    public subscript(_ name: String) -> CIFValueProtocol? {
        get { return try! get(name) }
        nonmutating set { return try! set(name, newValue) }
    }
}

/// Not possible for end-users to create manually.
public struct CIFPacketReference: CIFPacketProtocol {
    var _cPtr: CCIFPacketPointer
    public var cPtr: CCIFPacketPointer { return _cPtr }

    internal init(cPtr: CCIFPacketPointer) {
        _cPtr = cPtr
    }
}

/// Can be created.
public class CIFPacket: CIFPacketProtocol, ExpressibleByDictionaryLiteral {
    public typealias Key = String
    public typealias Value = CIFValue
    
    var _cPtr: CCIFPacketPointer
    public var cPtr: CCIFPacketPointer { return _cPtr }

    public init(names: [String]) throws {
        _cPtr = try CCIFPacketPointer.create(names)
    }
    
    internal init(_ cPtr: CCIFPacketPointer) {
        _cPtr = cPtr
    }
    
    public required convenience init(dictionaryLiteral elements: (String, CIFValue)...) {
        try! self.init(names: elements.map { $0.0 })
        for (k, v) in elements {
            self[k] = v
        }
    }
    
    deinit {
        _cPtr.free()
    }
}
