//
//  CCIFPointer.swift
//  CIFKitPackageDescription
//
//  Created by Dylan Lukes on 2/14/18.
//

import CCIF.Internal
import Foundation

public struct CCIFPointer: RawRepresentable {
    public typealias RawValue = UnsafeMutablePointer<cif_tp>
    
    public var rawValue: RawValue
    
    // MARK: - Lifecycle
    
    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }
    
    init?(rawValue: RawValue?) {
        guard let rawValue = rawValue else { return nil }
        self.rawValue = rawValue
    }
    
    static func create() throws -> CCIFPointer {
        var ptr: RawValue?
        let ret = cif_create(&ptr).retCode
        guard case .ok = ret, ptr != nil else {
            throw ret
        }
        return CCIFPointer(rawValue: ptr!)
    }
    
    func destroy() {
        // The only error this might emit is invalid handle.
        let _ = cif_destroy(rawValue)
    }
    
    func createBlock(_ code: String) throws -> CCIFContainerPointer {
        var ptr: CCIFContainerPointer.RawValue?
        let ret = cif_create_block(rawValue, code.utf16CString, &ptr).retCode
        guard case .ok = ret, ptr != nil else {
            throw ret
        }
        return CCIFContainerPointer(rawValue: ptr!)
    }
    
    func getBlock(_ code: String) throws -> CCIFContainerPointer? {
        var ptr: CCIFContainerPointer.RawValue?
        let ret = cif_get_block(rawValue, code.utf16CString, &ptr).retCode
        guard case .ok = ret, ptr != nil else {
            if case .noSuchBlock = ret {
                return nil
            }
            throw ret
        }
        return CCIFContainerPointer(rawValue: ptr!)
    }
}
