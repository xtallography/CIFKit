//
//  String+Unicode.swift
//  CIFKitPackageDescription
//
//  Created by Dylan Lukes on 1/25/18.
//

import Foundation

extension String {
    /// Returns a null terminated sequence of UTF-16 code units.
    var utf16CString: Array<UTF16.CodeUnit> {
        return ContiguousArray(self.utf16) + [0]
    }
    
    /// Returns an unmanaged copy of a terminated sequence of UTF-16 code units.
    /// The result of this function must be freed by the callee. 
    var unmanagedUTF16CString: UnsafeMutablePointer<UInt16> {
        var uchars = utf16CString
        let ptr: UnsafeMutablePointer<UInt16> = .allocate(capacity: uchars.count)
        
        uchars.withUnsafeMutableBufferPointer {
            ptr.moveInitialize(from: $0.baseAddress!, count: $0.count)
        }
        
        return ptr
    }
}
