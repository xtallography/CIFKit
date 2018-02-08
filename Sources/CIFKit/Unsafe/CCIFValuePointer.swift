import CCIF.Internal
import CCIF.Shims
import Foundation

/// This RawRepresentable provides the lowest level Swift bindings, and does not
/// handle any aspects of memory management. Each method corresponds to one
/// cif_api function, though some functions with overloaded behavior
/// have been expanded out for clarity (remove => take/remove), and some
/// have been lightly renamed for consistency.
public struct CCIFValuePointer: RawRepresentable {
    public typealias RawValue = UnsafeMutablePointer<cif_value_tp>

    public var rawValue: RawValue

    public init?(rawValue: RawValue) {
        self.rawValue = rawValue
    }

    /// Intended to simplify some nil-checking by allowing optional-chaining
    /// through a constructor.
    init?(rawValue: RawValue?) {
        guard let rawValue = rawValue else { return nil }
        self.rawValue = rawValue
    }

    static func create(kind: cif_kind_tp) throws -> CCIFValuePointer {
        var _ptr: RawValue?
        let ret = cif_value_create(kind, &_ptr).retCode
        guard case .ok = ret, case let ptr? = _ptr else { throw ret }
        return CCIFValuePointer(rawValue: ptr)!
    }

    func clean() {
        cif_value_clean(rawValue)
    }

    func free() {
        cif_value_free(rawValue)
    }

    func clone() throws -> CCIFValuePointer {
        var clone: RawValue?

        let ret = cif_value_clone(rawValue, &clone).retCode
        guard case .ok = ret, clone != nil else { throw ret }

        return CCIFValuePointer(rawValue: clone!)!
    }

    func clone(onto: CCIFValuePointer) throws {
        var tmp: RawValue? = onto.rawValue
        let ret = cif_value_clone(rawValue, &tmp).retCode
        guard case .ok = ret else { throw ret }
    }

    // MARK: - (Re)initialization

    func reinitialize(_ string: String) throws {
        let ret = cif_value_copy_char(rawValue, string.utf16CString).retCode
        guard case .ok = ret else { throw ret }
    }

    func reinitialize(takingCodeUnits ptr: UnsafeMutablePointer<UTF16.CodeUnit>) throws {
        let ret = cif_value_init_char(rawValue, ptr).retCode
        guard case .ok = ret else { throw ret }
    }

    func reinitialize(kind: cif_kind_tp) throws {
        let ret = cif_value_init(rawValue, kind).retCode
        guard case .ok = ret else { throw ret }
    }

    func reinitialize(_ value: Double, uncertainty: Double, scale: Int, maxLeadingZeroes: Int) throws {

        let ret = cif_value_init_numb(rawValue, value, uncertainty, Int32(scale), Int32(maxLeadingZeroes)).retCode
        guard case .ok = ret else { throw ret }
    }

    func reinitialize(_ value: Double, uncertainty: Double, roundingRule: Int) throws {
        let ret = cif_value_autoinit_numb(rawValue, value, uncertainty, UInt32(roundingRule)).retCode
        guard case .ok = ret else { throw ret }
    }

    // MARK: - Kind and Quote Status

    func getKind() -> cif_kind_tp {
        return cif_value_kind(rawValue)
    }

    func getQuoting() -> cif_quoted_tp {
        return cif_value_is_quoted(rawValue)
    }

    func setQuoting(_ quoteStatus: cif_quoted_tp) throws {
        let ret = cif_value_set_quoted(rawValue, quoteStatus).retCode
        guard case .ok = ret else { throw ret }
    }

    // MARK: - Number Methods

    func getNumber() throws -> Double {
        var val: Double = 0.0
        let ret = cif_value_get_number(rawValue, &val).retCode
        guard case .ok = ret else { throw ret }
        return val
    }

    func getUncertainty() throws -> Double {
        var su: Double = 0.0
        let ret = cif_value_get_su(rawValue, &su).retCode
        guard case .ok = ret else { throw ret }
        return su
    }

    // MARK: - String Methods

    func getText() throws -> String {
        var uchars: UnsafeMutablePointer<UTF16.CodeUnit>?
        let ret = cif_value_get_text(rawValue, &uchars).retCode
        guard case .ok = ret, let cString = uchars else { throw ret }
        return String(decodingCString: cString, as: UTF16.self)
    }

    // MARK: - Aggregate Methods

    func getElementCount() throws -> Int {
        var count = 0
        let ret = cif_value_get_element_count(rawValue, &count).retCode
        guard case .ok = ret else { throw ret }
        return count
    }

    // MARK: List Methods

    func get(at i: Int) throws -> CCIFValuePointer {
        var ptr: RawValue?
        let ret = cif_value_get_element_at(rawValue, i, &ptr).retCode
        guard case .ok = ret, let element = CCIFValuePointer(rawValue: ptr) else { throw ret }
        return element
    }

    func set(at i: Int, toCopyOf valuePtr: CCIFValuePointer) throws {
        let ret = cif_value_set_element_at(rawValue, i, valuePtr.rawValue).retCode
        guard case .ok = ret else { throw ret }
    }

    func insert(at i: Int, toCopyOf valuePtr: CCIFValuePointer) throws {
        let ret = cif_value_insert_element_at(rawValue, i, valuePtr.rawValue).retCode
        guard case .ok = ret else { throw ret }
    }

    func remove(at i: Int) throws {
        let ret = cif_value_remove_element_at(rawValue, i, nil).retCode
        guard case .ok = ret else { throw ret }
    }

    func take(at i: Int) throws -> CCIFValuePointer {
        var ptr: RawValue?
        let ret = cif_value_remove_element_at(rawValue, i, &ptr).retCode
        guard case .ok = ret, let element = CCIFValuePointer(rawValue: ptr) else { throw ret }
        return element
    }

    // MARK: Table Methods

    func getItemKeys() throws -> [String] {
        var ptr: UnsafeMutablePointer<UnsafePointer<UTF16.CodeUnit>?>?
        let ret = cif_value_get_keys(rawValue, &ptr).retCode
        guard case .ok = ret else { throw ret }

        // Iterates an array of pointers until a NULL/nil terminator.
        let iter = (0...).lazy.map { ptr![$0] }.prefix { $0 != nil }

        return iter.flatMap { String(decodingCString: $0!, as: UTF16.self) }
    }
    
    func has(key: String) throws -> Bool {
        let ret = cif_value_get_item_by_key(rawValue, key.utf16CString, nil).retCode
        guard case .ok = ret else {
            if case .noSuchItem = ret { return false }
            throw ret
        }
        return true
    }

    func get(key: String) throws -> CCIFValuePointer {
        var ptr: RawValue?
        let ret = cif_value_get_item_by_key(rawValue, key.utf16CString, &ptr).retCode
        guard case .ok = ret, let item = CCIFValuePointer(rawValue: ptr) else {
            throw ret
        }
        return item
    }

    func set(key: String, toCopyOf item: CCIFValuePointer) throws {
        let ret = cif_value_set_item_by_key(rawValue, key.utf16CString, item.rawValue).retCode
        guard case .ok = ret else { throw ret }
    }

    func remove(key: String) throws {
        let ret = cif_value_remove_item_by_key(rawValue, key.utf16CString, nil).retCode
        guard case .ok = ret else { throw ret }
    }

    func take(key: String) throws -> CCIFValuePointer {
        var ptr: RawValue?
        let ret = cif_value_remove_item_by_key(rawValue, key.utf16CString, &ptr).retCode
        guard case .ok = ret, let item = CCIFValuePointer(rawValue: ptr) else {
            throw ret
        }
        return item
    }
}
