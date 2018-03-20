import Foundation

typealias UMP = UnsafeMutablePointer
typealias UMBP = UnsafeMutableBufferPointer

extension String {
    /// Returns a null terminated sequence of UTF-16 code units.
    var utf16CString: Array<UTF16.CodeUnit> {
        return ContiguousArray(utf16) + [0]
    }

    /// Returns an unmanaged copy of a terminated sequence of UTF-16 code units.
    /// The result of this function must be freed by the callee.
    var unmanagedUTF16CString: (UMBP<UInt16>, (UMBP<UInt16>) -> Void) {
        let ptr: UMP<UInt16> = .allocate(capacity: utf16.count + 1)
        let buf = UMBP(start: ptr, count: utf16.count + 1)
        
        let (_, termIndex) = buf.initialize(from: utf16)
        buf[termIndex] = 0

        return (buf, { buf in
            buf.baseAddress?.deinitialize(count: buf.count)
            buf.baseAddress?.deallocate()
        })
    }
}

extension Array where Element == String {
    var utf16CStrings: Array<Array<UTF16.CodeUnit>> {
        return self.map { $0.utf16CString }
    }
    
    var unmanagedUTF16CStrings: (UMBP<UMP<UInt16>?>, (UMBP<UMP<UInt16>?>) -> Void) {
        let ptr: UMP<UMP<UInt16>?> = .allocate(capacity: count + 1)
        let buf = UMBP(start: ptr, count: count + 1)
        
        let elts = self.map({ $0.unmanagedUTF16CString })
        
        let (_, termIndex) = buf.initialize(from: elts.map { $0.0.baseAddress })
        buf[termIndex] = nil
        
        return (buf, { buf in
            elts.forEach({ (buf, dtor) in dtor(buf) })
            buf.baseAddress?.deinitialize(count: buf.count)
            buf.baseAddress?.deallocate()
        })
    }
}
