import CCIF
import CCIF.Internal

public class CCIFParserOptionsPointer: RawRepresentable {
    public typealias RawValue = UnsafeMutablePointer<cif_parse_opts_s>
    
    public var rawValue: RawValue
    
    // MARK: - Lifecycle
    
    public required init(rawValue: RawValue) {
        self.rawValue = rawValue
    }
    
    public init() throws {
        var ptr: RawValue?
        let ret = cif_parse_options_create(&ptr).retCode
        guard case .ok = ret, ptr != nil else {
            // Note: does this ever really throw?
            throw ret
        }
        self.rawValue = ptr!
    }
    
    deinit {
        Compat.free(rawValue)
    }
    
    public enum VersionPreference: CInt {
        case automatic = 0
        case forceCIF11 = -1 // < 0
        case forceCIF20 = 21 // > 20
        
        public init(rawValue: CInt) {
            if rawValue > 20 {
                self = .forceCIF20
            }
            if rawValue < 0 {
                self = .forceCIF11
            }
            self = .automatic
        }
    }
    
    public var preferCIF2: VersionPreference {
        get {
            return VersionPreference(rawValue: rawValue.pointee.prefer_cif2)
        }
        set {
            rawValue.pointee.prefer_cif2 = newValue.rawValue
        }
    }
}
