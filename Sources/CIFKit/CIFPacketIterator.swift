import Foundation

public class CIFPacketIterator: IteratorProtocol {
    public typealias Element = CIFPacket
    
    var cPtr: CCIFPacketIteratorPointer
    
    internal init(_ cPtr: CCIFPacketIteratorPointer) {
        self.cPtr = cPtr
    }
    
    func close() throws {
        try cPtr.close()
    }
    
    func abort() throws {
        try cPtr.abort()
    }
    
    public func next() -> CIFPacket? {
        return (try? cPtr.nextPacket())?.flatMap(CIFPacket.init)
    }
    
    // TODO: update/remove aren't easily shoehorned into IteratorProtocol.
    // Are they necessary?
}
