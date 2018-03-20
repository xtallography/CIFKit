import CCIF.Internal
import Foundation

public struct CCIFContainerPointer: RawRepresentable {
    public typealias RawValue = UnsafeMutablePointer<cif_container_tp>
    
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
        cif_container_free(rawValue)
    }
    
    func destroy() throws {
        let ret = cif_container_destroy(rawValue).retCode
        guard case .ok = ret else {
            throw ret
        }
    }
    
    func getFrame(_ code: String) throws -> CCIFContainerPointer? {
        var ptr: RawValue?
        let ret = cif_container_get_frame(rawValue, code.utf16CString, &ptr).retCode
        guard case .ok = ret else {
            if case .noSuchFrame = ret {
                return nil
            }
            throw ret
        }
        return CCIFContainerPointer(rawValue: ptr!)
    }
    
    func getAllFrames() throws -> [CCIFContainerPointer] {
        var ptr: UnsafeMutablePointer<RawValue?>?
        
        let ret = cif_container_get_all_frames(rawValue, &ptr).retCode
        guard case .ok = ret else {
            throw ret
        }
        
        defer {
            Compat.free(ptr)
        }
        
        // Iterates an array of pointers until a NULL/nil terminator.
        let iter = (0...).lazy.map { CCIFContainerPointer(rawValue: ptr![$0]) }.prefix { $0 != nil }
        return iter.compactMap { $0 }
    }
    
    func getCode() throws -> String {
        var ptr: UnsafeMutablePointer<UTF16.CodeUnit>?
        
        let ret = cif_container_get_code(rawValue, &ptr).retCode
        guard case .ok = ret, ptr != nil else {
            throw ret
        }
        
        return String.init(decodingCString: ptr!, as: UTF16.self)
    }
    
    func assertBlock() throws {
        let ret = cif_container_assert_block(rawValue).retCode
        guard case .ok = ret else {
            throw ret
        }
    }
    
    func createLoop(category: String?, names: [String]) throws -> CCIFLoopPointer {
        var ptr: CCIFLoopPointer.RawValue?
        
        let (namesPtrs, namesDtor) = names.unmanagedUTF16CStrings
        defer {
            namesDtor(namesPtrs)
        }
        
        let ret = cif_container_create_loop(rawValue,
                                            category?.utf16CString,
                                            namesPtrs.baseAddress,
                                            &ptr).retCode
        guard case .ok = ret, ptr != nil else {
            throw ret
        }
        
        return CCIFLoopPointer(rawValue: ptr)!
    }
    
    func getLoop(category: String) throws -> CCIFLoopPointer? {
        var ptr: CCIFLoopPointer.RawValue?
        
        let ret = cif_container_get_category_loop(rawValue, category.utf16CString, &ptr).retCode
        guard case .ok = ret, ptr != nil else {
            if case .noSuchLoop = ret {
                return nil
            }
            throw ret
        }
        
        return CCIFLoopPointer(rawValue: ptr)!
    }
    
    func getLoop(itemName: String) throws -> CCIFLoopPointer? {
        var ptr: CCIFLoopPointer.RawValue?
        
        let ret = cif_container_get_category_loop(rawValue, itemName.utf16CString, &ptr).retCode
        guard case .ok = ret, ptr != nil else {
            if case .noSuchItem = ret {
                return nil
            }
            throw ret
        }
        
        return CCIFLoopPointer(rawValue: ptr!)
    }
    
    func getAllLoops() throws -> [CCIFLoopPointer] {
        var ptr: UnsafeMutablePointer<CCIFLoopPointer.RawValue?>?
        
        let ret = cif_container_get_all_loops(rawValue, &ptr).retCode
        guard case .ok = ret else {
            throw ret
        }
        
        defer {
            Compat.free(ptr)
        }
        
        let iter = (0...).lazy.map { CCIFLoopPointer(rawValue: ptr![$0]) }.prefix { $0 != nil }
        return iter.compactMap { $0 }
    }
    
    func prune() throws {
        let ret = cif_container_prune(rawValue).retCode
        guard case .ok = ret else {
            throw ret
        }
    }
    
    func getValue(itemName: String) throws -> CCIFValuePointer? {
        var ptr: CCIFValuePointer.RawValue?
        
        let ret = cif_container_get_value(rawValue, itemName.utf16CString, &ptr).retCode
        guard case .ok = ret else {
            if case .noSuchItem = ret {
                return nil
            }
            throw ret
        }
        
        return CCIFValuePointer(rawValue: ptr!)
    }
    
    func setValue(itemName: String, value: CCIFValuePointer) throws {
        let ret = cif_container_set_value(rawValue, itemName.utf16CString, value.rawValue).retCode
        guard case .ok = ret else {
            throw ret
        }
    }
    
    func removeItem(itemName: String) throws {
        let ret = cif_container_remove_item(rawValue, itemName.utf16CString).retCode
        guard case .ok = ret else {
            throw ret
        }
    }
}
