import Foundation

public class CIFLoopHandle {
    internal var cPtr: CCIFLoopPointer
    
    internal init(cPtr: CCIFLoopPointer) {
        self.cPtr = cPtr
    }
    
    public func free() {
        cPtr.free()
    }
    
    public func destroy() throws {
        try cPtr.destroy()
    }
    
    public func getCategory() throws -> String {
        return try cPtr.getCategory()
    }
    
    public func setCategory(_ category: String) throws {
        try cPtr.setCategory(category)
    }
    
    public func getNames() throws -> [String] {
        return try cPtr.getNames()
    }
    
    public func append(item name: String, _ value: CIFValueProtocol) throws {
        try cPtr.addItem(name, value.cPtr)
    }
    
    public func append(packet: CIFPacketProtocol) throws {
        try cPtr.addPacket(packet.cPtr)
    }
}

