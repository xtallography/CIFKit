//
//  Compat.swift
//  CIFKitPackageDescription
//
//  Created by Dylan Lukes on 2/8/18.
//

#if os(Linux) || os(FreeBSD)
    import Glibc
#else
    import Darwin
#endif

/// Compat is a bundle of static methods intended to plaster over
/// differences in C stdlib. See the above conditional directives.
enum Compat {
    static func free(_ ptr: UnsafeMutableRawPointer!) {
        #if os(Linux) || os(FreeBSD)
            Glibc.free(ptr)
        #else
            Darwin.free(ptr)
        #endif
    }
}
