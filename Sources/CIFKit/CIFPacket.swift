//
//  CIFPacket.swift
//  CIFKit
//
//  Created by Dylan Lukes on 2/6/18.
//

import Foundation

public protocol CIFPacketProtocol {
    var cPtr: CCIFPacketPointer { get }
}

extension CIFPacketProtocol {
    public var names: [String] {
        return try! cPtr.getNames()
    }
    
    public func get(_ name: String) throws -> CIFValueReference {
        let ptr = try cPtr.get(name)!
        return CIFValueReference(ptr)
    }
    
    public func set(_ name: String, _ value: CIFValueProtocol) throws {
        try cPtr.set(name, value.cPtr)
    }
}

/// Not possible for end-users to create manually.
public struct CIFPacketReference: CIFPacketProtocol {
    var _cPtr: CCIFPacketPointer
    public var cPtr: CCIFPacketPointer { return _cPtr }

    internal init(_ cPtr: CCIFPacketPointer) {
        _cPtr = cPtr
    }
}

/// Can be created.
public class CIFPacketObject: CIFPacketProtocol {
    var _cPtr: CCIFPacketPointer
    public var cPtr: CCIFPacketPointer { return _cPtr }

    public init(names: [String]) throws {
        _cPtr = try CCIFPacketPointer.create(names)
    }
    
    deinit {
        _cPtr.free()
    }
}
