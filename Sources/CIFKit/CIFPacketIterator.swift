//
//  CIFPacketIterator.swift
//  CIFKitPackageDescription
//
//  Created by Dylan Lukes on 2/8/18.
//

import Foundation

public class CIFPacketIterator: IteratorProtocol {
    public typealias Element = CIFPacketObject
    
    var cPtr: CCIFPacketIteratorPointer
    
    internal init(_ cPtr: CCIFPacketIteratorPointer) {
        self.cPtr = cPtr
    }
    
    func close() throws {
        try cPtr.close()
    }
    
    func abort() throws {
        try cPtr.abort()
    }
    
    public func next() -> CIFPacketObject? {
        return (try? cPtr.nextPacket())?.flatMap(CIFPacketObject.init)
    }
    
    // TODO: update/remove aren't easily shoehorned into IteratorProtocol.
    // Are they necessary?
}
