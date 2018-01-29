import Foundation
import CCIF.Internal
import CCIF.Shims

public typealias CCIFValuePointer = UnsafeMutablePointer<cif_value_tp>

/// Extensions for UnsafeMutablePointer where the pointee is a CIF value.
/// This extension provides the lowest level Swift bindings, and does not
/// handle any aspects of memory management. Each method corresponds to one
/// cif_api function, though some functions with overloaded behavior
/// have been expanded out for clarity (remove => take/remove), and some
/// have been lightly renamed for consistency.
///
/// Additionally, where lossless conversions are possible, the API has been updated ot use appropriate Swift types in parameter positions (e.g. String rather than uchar *).
extension UnsafeMutablePointer where Pointee == cif_value_tp {
    static func create(kind: cif_kind_tp) throws -> CCIFValuePointer {
        var _ptr: CCIFValuePointer? = nil
        let ret = cif_value_create(kind, &_ptr).retCode
        guard case .ok = ret, case let ptr? = _ptr else { throw ret }
        return ptr
    }
    
    func clean() -> Void {
        cif_value_clean(self)
    }
    
    func free() -> Void {
        cif_value_free(self)
    }
    
    func clone() throws -> CCIFValuePointer {
        var clone: CCIFValuePointer? = nil
        
        let ret = cif_value_clone(self, &clone).retCode
        guard case .ok = ret else { throw ret }
        
        return clone!
    }
    
    func clone(onto: CCIFValuePointer) throws {
        var tmp: CCIFValuePointer? = onto
        let ret = cif_value_clone(self, &tmp).retCode
        guard case .ok = ret else { throw ret }
    }
    
    // MARK: - (Re)initialization
    
    func reinitialize(_ string: String) throws {
        let ret =  cif_value_copy_char(self, string.utf16CString).retCode
        guard case .ok = ret else { throw ret }
    }
    
    func reinitialize(takingCodeUnits ptr: UnsafeMutablePointer<UTF16.CodeUnit>) throws {
        let ret = cif_value_init_char(self, ptr).retCode
        guard case .ok = ret else { throw ret }
    }
    
    func reinitialize(kind: cif_kind_tp) throws {
        let ret = cif_value_init(self, kind).retCode
        guard case .ok = ret else { throw ret }
    }
    
    func reinitialize(_ value: Double, uncertainty: Double, scale: Int, maxLeadingZeroes: Int) throws {
        
        let ret = cif_value_init_numb(self, value, uncertainty, Int32(scale), Int32(maxLeadingZeroes)).retCode
        guard case .ok = ret else { throw ret }
    }
    
    func reinitialize(_ value: Double, uncertainty: Double, roundingRule: Int) throws {
        let ret = cif_value_autoinit_numb(self, value, uncertainty, UInt32(roundingRule)).retCode
        guard case .ok = ret else { throw ret }
    }
    
    // MARK: - Kind and Quote Status
    
    func getKind() -> cif_kind_tp {
        return cif_value_kind(self)
    }
    
    func getQuoting() -> cif_quoted_tp {
        return cif_value_is_quoted(self)
    }
    
    func setQuoting(_ quoteStatus: cif_quoted_tp) throws {
        let ret = cif_value_set_quoted(self, quoteStatus).retCode
        guard case .ok = ret else { throw ret }
    }
    
    // MARK: - Number Methods

    func getNumber() throws -> Double {
        var val: Double = 0.0
        let ret = cif_value_get_number(self, &val).retCode
        guard case .ok = ret else { throw ret }
        return val
    }
    
    func getUncertainty() throws -> Double {
        var su: Double = 0.0
        let ret = cif_value_get_su(self, &su).retCode
        guard case .ok = ret else { throw ret }
        return su
    }
    
    // MARK: - String Methods
    
    func getText() throws -> String {
        var uchars: UnsafeMutablePointer<UTF16.CodeUnit>?
        let ret = cif_value_get_text(self, &uchars).retCode
        guard case .ok = ret, let cString = uchars else { throw ret }
        return String(decodingCString: cString, as: UTF16.self)
    }
    
    // MARK: - Aggregate Methods
    
    func getElementCount() throws -> Int {
        var count = 0
        let ret = cif_value_get_element_count(self, &count).retCode
        guard case .ok = ret else { throw ret }
        return count
    }
    
    // MARK: List Methods
    
    func get(at i: Int) throws -> CCIFValuePointer {
        var ptr: CCIFValuePointer?
        let ret = cif_value_get_element_at(self, i, &ptr).retCode
        guard case .ok = ret, let element = ptr else { throw ret }
        return element
    }
    
    func set(at i: Int, toCopyOf value: CCIFValuePointer) throws -> Void {
        let ret = cif_value_set_element_at(self, i, value).retCode
        guard case .ok = ret else { throw ret }
    }
    
    func insert(at i: Int, toCopyOf value: CCIFValuePointer) throws -> Void {
        let ret = cif_value_insert_element_at(self, i, value).retCode
        guard case .ok = ret else { throw ret }
    }
    
    func remove(at i: Int) throws -> Void {
        let ret = cif_value_remove_element_at(self, i, nil).retCode
        guard case .ok = ret else { throw ret }
    }
    
    func take(at i: Int) throws -> CCIFValuePointer {
        var ptr: CCIFValuePointer?
        let ret = cif_value_remove_element_at(self, i, &ptr).retCode
        guard case .ok = ret, let element = ptr else { throw ret }
        return element
    }
    
    // MARK: Table Methods
    
    func getItemKeys() throws -> [String] {
        var ptr: UnsafeMutablePointer<UnsafePointer<UTF16.CodeUnit>?>?
        let ret = cif_value_get_keys(self, &ptr).retCode
        guard case .ok = ret else { throw ret }
        
        // Iterates an array of pointers until a NULL/nil terminator.
        let iter = (0...).lazy.map { ptr![$0] }.prefix { $0 != nil }
        
        return iter.flatMap { String(decodingCString: $0!, as: UTF16.self) }
    }
    
    func get(key: String) throws -> CCIFValuePointer {
        var ptr: CCIFValuePointer? = nil
        let ret = cif_value_get_item_by_key(self, key.utf16CString, &ptr).retCode
        guard case .ok = ret, let item = ptr else { throw ret }
        return item
    }
    
    func set(key: String, toCopyOf item: CCIFValuePointer) throws {
        let ret = cif_value_set_item_by_key(self, key.utf16CString, item).retCode
        guard case .ok = ret else { throw ret }
    }
    
    func remove(key: String) throws -> Void {
        let ret = cif_value_remove_item_by_key(self, key.utf16CString, nil).retCode
        guard case .ok = ret else { throw ret }
    }
    
    func take(key: String) throws -> CCIFValuePointer {
        var ptr: CCIFValuePointer?
        let ret = cif_value_remove_item_by_key(self, key.utf16CString, &ptr).retCode
        guard case .ok = ret, let item = ptr else { throw ret }
        return item
    }
}

//
/// Creates an independent value object with identical contents.
//    public func clone() throws -> CIFValueObject {
//        var clonePtr: CCIFValuePointer? = nil
//
//        let ret = cif_value_clone(self.rawValue, &clonePtr).retCode
//        guard case .ok = ret, clonePtr != nil else { throw ret }
//
//        return CIFValueObject(rawValue: clonePtr!)
//    }

/// Writes the contents of this value object into another, either
/// independent, or a reference.
//    func clone(onto dest: inout CIFValueProtocol) throws {
//
//        let ret = cif_value_clone(self.rawValue, &x).retCode
//        guard case .ok = ret else { throw ret }
//    }
