import CCIF
import CCIF.Internal
import Foundation

public struct CCIFPacketIteratorPointer: RawRepresentable {
    public typealias RawValue = UnsafeMutablePointer<cif_pktitr_tp>
    
    public var rawValue: RawValue
    
    public init?(rawValue: RawValue) {
        self.rawValue = rawValue
    }
    
    func close() throws {
        let ret = cif_pktitr_close(rawValue).retCode
        guard case .ok = ret else {
            throw ret
        }
    }
    
    func abort() throws {
        let ret = cif_pktitr_abort(rawValue).retCode
        guard case .ok = ret else {
            throw ret
        }
    }
    
    func nextPacket() throws -> CCIFPacketPointer? {
        var ptr: CCIFPacketPointer.RawValue?
        let ret = cif_pktitr_next_packet(rawValue, &ptr).retCode
        guard case .ok = ret, ptr != nil else {
            if case .finished = ret {
                return nil
            }
            throw ret
        }
        
        return CCIFPacketPointer(rawValue: ptr!)
    }
    
    func removeLastIteratedPacket() throws {
        let ret = cif_pktitr_remove_packet(rawValue).retCode
        guard case .ok = ret else {
            throw ret
        }
    }
    
    func updateLastIteratedPacket(_ packet: CCIFPacketPointer) throws {
        let ret = cif_pktitr_update_packet(rawValue, packet.rawValue).retCode
        guard case .ok = ret else {
            throw ret
        }
    }
}
