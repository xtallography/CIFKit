import Foundation

public class CIFContainerHandle {
    internal var cPtr: CCIFContainerPointer
        
    internal init(cPtr: CCIFContainerPointer) {
        self.cPtr = cPtr
    }
    
    internal convenience init?(cPtr: CCIFContainerPointer?) {
        guard let cPtr = cPtr else {
            return nil
        }
        self.init(cPtr: cPtr)
    }
    
    deinit {
        cPtr.free()
    }
    
    func destroy() throws {
        try cPtr.destroy()
    }
    
    func create(loop category: String?, names: [String]) throws {
        let _ = try cPtr.createLoop(category: category, names: names)
    }
    
    func create<Return>(loop category: String? = nil, names: [String], _ c: (CIFLoopHandle) throws -> Return) throws -> Return {
        let loop = try cPtr.createLoop(category: category, names: names)
        
        return try withExtendedLifetime(self) {
            return try c(CIFLoopHandle(cPtr: loop))
        }
    }
}
