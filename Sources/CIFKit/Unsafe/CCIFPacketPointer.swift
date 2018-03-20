import CCIF.Internal
import CCIF.Shims
import Foundation

public struct CCIFPacketPointer: RawRepresentable {
    public typealias RawValue = UnsafeMutablePointer<cif_packet_tp>

    public var rawValue: RawValue

    // MARK: - Lifecycle
    
    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }

    init?(rawValue: RawValue?) {
        guard let rawValue = rawValue else { return nil }
        self.rawValue = rawValue
    }

    static func create(_ names: [String]) throws -> CCIFPacketPointer {
        var _ptr: RawValue?

        let (namesPtrs, namesDtor) = names.unmanagedUTF16CStrings
        defer {
            namesDtor(namesPtrs)
        }
        
        let ret = cif_packet_create(&_ptr, namesPtrs.baseAddress).retCode
        guard case .ok = ret, case let ptr? = _ptr else {
            throw ret
        }
        
        return CCIFPacketPointer(rawValue: ptr)!
    }
    
    func free() {
        cif_packet_free(rawValue)
    }
    
    // MARK: - Map Functionality
    
    func getNames() throws -> [String] {
        var ptr: UnsafeMutablePointer<UnsafePointer<UTF16.CodeUnit>?>?
        
        let ret = cif_packet_get_names(rawValue, &ptr).retCode
        guard case .ok = ret else {
            throw ret
        }
        defer { Compat.free(ptr) }
        
        // Iterates an array of pointers until a NULL/nil terminator.
        let iter = (0...).lazy.map { ptr![$0] }.prefix { $0 != nil }
        return iter.compactMap { String(decodingCString: $0!, as: UTF16.self) }
    }
    
    func has(_ name: String) throws -> Bool {
        let ret = cif_packet_get_item(rawValue, name.utf16CString, nil).retCode
        guard case .ok = ret else {
            if ret == .noSuchItem { return false }
            throw ret
        }
        return true
    }
    
    func get(_ name: String) throws -> CCIFValuePointer? {
        var valPtr: CCIFValuePointer.RawValue?
        let ret = cif_packet_get_item(rawValue, name.utf16CString, &valPtr).retCode
        guard case .ok = ret, valPtr != nil else {
            if case .noSuchItem = ret { return nil }
            throw ret
        }
        return CCIFValuePointer(rawValue: valPtr)
    }
    
    func set(_ name: String, _ value: CCIFValuePointer?) throws -> Void {
        let ret = cif_packet_set_item(rawValue, name.utf16CString, value?.rawValue).retCode
        guard case .ok = ret else { throw ret }
    }
    
    func remove(_ name: String) throws {
        let ret = cif_packet_remove_item(rawValue, name.utf16CString, nil).retCode
        guard case .ok = ret else { throw ret }
    }
    
    func take(_ name: String) throws -> CCIFValuePointer {
        var valPtr: CCIFValuePointer.RawValue?
        let ret = cif_packet_remove_item(rawValue, name.utf16CString, &valPtr).retCode
        guard case .ok = ret, let element = CCIFValuePointer(rawValue: valPtr) else { throw ret }
        return element
    }
}


