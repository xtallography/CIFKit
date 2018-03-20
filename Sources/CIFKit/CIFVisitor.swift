import Foundation
import CCIF

public protocol CIFVisitor: AnyObject {
    func onCIFStart(_ cif: CIF) -> CIFAPIReturnCode
    func onCIFEnd(_ cif: CIF) -> CIFAPIReturnCode
    func onBlockStart(_ block: CIFContainerHandle) -> CIFAPIReturnCode
    func onBlockEnd(_ block: CIFContainerHandle) -> CIFAPIReturnCode
    func onFrameStart(_ frame: CIFContainerHandle) -> CIFAPIReturnCode
    func onFrameEnd(_ frame: CIFContainerHandle) -> CIFAPIReturnCode
    func onLoopStart(_ loop: CIFLoopHandle) -> CIFAPIReturnCode
    func onLoopEnd(_ loop: CIFLoopHandle) -> CIFAPIReturnCode
    func onPacketStart(_ packet: CIFPacketReference?) -> CIFAPIReturnCode
    func onPacketEnd(_ packet: CIFPacketReference) -> CIFAPIReturnCode
    func onItem(_ name: String?, _ value: CIFValueReference) -> CIFAPIReturnCode
}

extension CIFVisitor {
    func adapt() -> cif_handler_tp {
        return cif_handler_tp(
            handle_cif_start: {
                (unsafeCIFPtr: CCIFPointer.RawValue?, unsafeContextPtr: UnsafeMutableRawPointer?) -> Int32 in
                let unmanagedSelf: CIFVisitor = Unmanaged<AnyObject>
                    .fromOpaque(unsafeContextPtr!)
                    .takeUnretainedValue() as! CIFVisitor
                
                let cif = CIF(cPtr: CCIFPointer(rawValue: unsafeCIFPtr)!)
                return unmanagedSelf.onCIFStart(cif).rawValue
            },
            handle_cif_end: { (unsafeCIFPtr: CCIFPointer.RawValue?, unsafeContextPtr: UnsafeMutableRawPointer?) -> Int32 in
                let unmanagedSelf: CIFVisitor = Unmanaged<AnyObject>
                    .fromOpaque(unsafeContextPtr!)
                    .takeUnretainedValue() as! CIFVisitor
                
                let cif = CIF(cPtr: CCIFPointer(rawValue: unsafeCIFPtr)!)
                return unmanagedSelf.onCIFEnd(cif).rawValue
            },
            handle_block_start: { (unsafeBlockPtr: CCIFContainerPointer.RawValue?, unsafeContextPtr: UnsafeMutableRawPointer?) -> Int32 in
                let unmanagedSelf: CIFVisitor = Unmanaged<AnyObject>
                    .fromOpaque(unsafeContextPtr!)
                    .takeUnretainedValue() as! CIFVisitor
                
                let block = CIFContainerHandle(cPtr: CCIFContainerPointer(rawValue: unsafeBlockPtr)!)
                return unmanagedSelf.onBlockStart(block).rawValue
            },
            handle_block_end: { (unsafeBlockPtr: CCIFContainerPointer.RawValue?, unsafeContextPtr: UnsafeMutableRawPointer?) -> Int32 in
                let unmanagedSelf: CIFVisitor = Unmanaged<AnyObject>
                    .fromOpaque(unsafeContextPtr!)
                    .takeUnretainedValue() as! CIFVisitor
                
                let block = CIFContainerHandle(cPtr: CCIFContainerPointer(rawValue: unsafeBlockPtr)!)
                return unmanagedSelf.onBlockEnd(block).rawValue
            },
            handle_frame_start: { (unsafeFramePtr: CCIFContainerPointer.RawValue?, unsafeContextPtr: UnsafeMutableRawPointer?) -> Int32 in
                let unmanagedSelf: CIFVisitor = Unmanaged<AnyObject>
                    .fromOpaque(unsafeContextPtr!)
                    .takeUnretainedValue() as! CIFVisitor
                
                let frame = CIFContainerHandle(cPtr: CCIFContainerPointer(rawValue: unsafeFramePtr)!)
                return unmanagedSelf.onFrameStart(frame).rawValue
            },
            handle_frame_end: { (unsafeFramePtr: CCIFContainerPointer.RawValue?, unsafeContextPtr: UnsafeMutableRawPointer?) -> Int32 in
                let unmanagedSelf: CIFVisitor = Unmanaged<AnyObject>
                    .fromOpaque(unsafeContextPtr!)
                    .takeUnretainedValue() as! CIFVisitor
                
                let frame = CIFContainerHandle(cPtr: CCIFContainerPointer(rawValue: unsafeFramePtr)!)
                return unmanagedSelf.onFrameEnd(frame).rawValue
            },
            handle_loop_start: { (unsafeLoopPtr: CCIFLoopPointer.RawValue?, unsafeContextPtr: UnsafeMutableRawPointer?) -> Int32 in
                let unmanagedSelf: CIFVisitor = Unmanaged<AnyObject>
                    .fromOpaque(unsafeContextPtr!)
                    .takeUnretainedValue() as! CIFVisitor
                
                let loop = CIFLoopHandle(cPtr: CCIFLoopPointer(rawValue: unsafeLoopPtr)!)
                return unmanagedSelf.onLoopStart(loop).rawValue
            },
            handle_loop_end: { (unsafeLoopPtr: CCIFLoopPointer.RawValue?, unsafeContextPtr: UnsafeMutableRawPointer?) -> Int32 in
                let unmanagedSelf: CIFVisitor = Unmanaged<AnyObject>
                    .fromOpaque(unsafeContextPtr!)
                    .takeUnretainedValue() as! CIFVisitor
                
                let loop = CIFLoopHandle(cPtr: CCIFLoopPointer(rawValue: unsafeLoopPtr)!)
                return unmanagedSelf.onLoopEnd(loop).rawValue
            },
            handle_packet_start: { (unsafePacketPtr: CCIFPacketPointer.RawValue?, unsafeContextPtr: UnsafeMutableRawPointer?) -> Int32 in
                let unmanagedSelf: CIFVisitor = Unmanaged<AnyObject>
                    .fromOpaque(unsafeContextPtr!)
                    .takeUnretainedValue() as! CIFVisitor
                
                let packet = CCIFPacketPointer(rawValue: unsafePacketPtr).map { CIFPacketReference(cPtr: $0) }
                return unmanagedSelf.onPacketStart(packet).rawValue
            },
            handle_packet_end: { (unsafePacketPtr: CCIFPacketPointer.RawValue?, unsafeContextPtr: UnsafeMutableRawPointer?) -> Int32 in
                let unmanagedSelf: CIFVisitor = Unmanaged<AnyObject>
                    .fromOpaque(unsafeContextPtr!)
                    .takeUnretainedValue() as! CIFVisitor
                
                let packet = CIFPacketReference(cPtr: CCIFPacketPointer(rawValue: unsafePacketPtr)!)
                return unmanagedSelf.onPacketEnd(packet).rawValue
            },
            handle_item: { (namePtr: UnsafeMutablePointer<UChar>?, unsafeValuePtr: CCIFValuePointer.RawValue?, unsafeContextPtr: UnsafeMutableRawPointer?) -> Int32 in
                let unmanagedSelf: CIFVisitor = Unmanaged<AnyObject>
                    .fromOpaque(unsafeContextPtr!)
                    .takeUnretainedValue() as! CIFVisitor
                
                let name = namePtr.map { String(decodingCString: $0, as: UTF16.self) }
                let value = CIFValueReference(CCIFValuePointer(rawValue: unsafeValuePtr)!)
                return unmanagedSelf.onItem(name, value).rawValue
        })
    }
}
