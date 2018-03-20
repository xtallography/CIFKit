//
//  CIF.swift
//  CIFKitPackageDescription
//
//  Created by Dylan Lukes on 2/14/18.
//

import Foundation

public class CIF {
    internal var cPtr: CCIFPointer
    
    internal init(cPtr: CCIFPointer) {
        self.cPtr = cPtr
    }
    
    public convenience init() {
        self.init(cPtr: try! CCIFPointer.create())
    }
    
    deinit {
        cPtr.destroy()
    }
    
    public func create(block code: String) throws {
        let _ = try cPtr.createBlock(code)
    }
    
    public func create<Return>(block code: String, _ cont: (CIFContainerHandle) throws -> Return) throws -> Return {
        let blockPtr = try cPtr.createBlock(code)
        
        return try withExtendedLifetime(self) {
            return try cont(CIFContainerHandle(cPtr: blockPtr))
        }
    }
    
    public func with<Return>(block code: String, _ cont: (CIFContainerHandle?) throws -> Return) throws -> Return {
        let blockPtr = try cPtr.getBlock(code)
        
        return try withExtendedLifetime(self) {
            return try cont(CIFContainerHandle(cPtr: blockPtr))
        }
    }
}
