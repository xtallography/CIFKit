import CCIF.Internal
import Foundation

public struct CCIFLoopPointer: RawRepresentable {
    public typealias RawValue = UnsafeMutablePointer<cif_loop_tp>
    
    public var rawValue: RawValue
    
    // MARK: - Lifecycle
    
    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }
    
    init?(rawValue: RawValue?) {
        guard let rawValue = rawValue else { return nil }
        self.rawValue = rawValue
    }

    func free() {
        cif_loop_free(rawValue)
    }
    
    func destroy() throws {
        let ret = cif_loop_destroy(rawValue).retCode
        guard case .ok = ret else {
            throw ret
        }
    }
    
    func getCategory() throws -> String {
        var uchars: UnsafeMutablePointer<UTF16.CodeUnit>?
        let ret = cif_loop_get_category(rawValue, &uchars).retCode
        guard case .ok = ret, let cString = uchars else {
            throw ret
        }
        defer {
            // Gospel: Responsibility for cleaning up the category string
            // belongs to the caller.
            Darwin.free(uchars)
        }
        return String(decodingCString: cString, as: UTF16.self)
    }
    
    func setCategory(_ category: String) throws {
        let ret = cif_loop_set_category(rawValue, category.utf16CString).retCode
        guard case .ok = ret else {
            throw ret
        }
    }
    
    func getNames() throws -> [String] {
        var ptr: UnsafeMutablePointer<UnsafeMutablePointer<UTF16.CodeUnit>?>?
        
        let ret = cif_loop_get_names(rawValue, &ptr).retCode
        guard case .ok = ret else {
            throw ret
        }
        
        // Iterates an array of pointers until a NULL/nil terminator.
        let iter = (0...).lazy.map { ptr![$0] }.prefix { $0 != nil }
        
        defer {
            // Gospel: We assume responsibility for freeing the individual
            // names and the array containing them. Copies are returned.
            iter.forEach { Compat.free($0) }
            Compat.free(ptr)
        }
        
        return iter.compactMap { String(decodingCString: $0!, as: UTF16.self) }
    }
    
    func addItem(_ name: String, _ value: CCIFValuePointer) throws {
        let ret = cif_loop_add_item(rawValue, name.utf16CString, value.rawValue).retCode
        guard case .ok = ret else {
            throw ret
        }
    }
    
    func addPacket(_ packet: CCIFPacketPointer) throws {
        let ret = cif_loop_add_packet(rawValue, packet.rawValue).retCode
        guard case .ok = ret else {
            throw ret
        }
    }
    
//    func getPackets() -> CCIFPacketIteratorPointer throws {
//
//    }
}
