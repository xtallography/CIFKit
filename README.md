# CIFKit

CIFKit is comprised of two major components:

1. Swift bindings for the COMCIFS reference implementation of the [CIF API](`COMCIFS/cif_api`).
  - Manipulating managed (opaque) CIFs backed by SQLite.
  - ...

2. _(In Progress)_ Special amenities for working with CIFs in Swift.
  - Data mapping from structs using `Codable`, with provided `Encoder` and `Decoder` instances.
  - Support for offloading portions of CIFs to custom representations.
  - ...

## Usage

CIFKit is currently only available through SPM (Swift Package Manager). Simply add to your dependencies:

```swift
.package(url: "https://github.com/xtallography/CIFKit", .upToNextMajor(from: "x.x.x"))
```

See the [Building](##Building) section for linkage details: on macOS, you will likely need to override `PKG_CONFIG_PATH` to ensure a complete (i.e. non-system provided) distribution of `icu4c` available at compile-time.

## Building

In macOS build environments, the system provides `libicu`, but does not provide headers nor pkgconfig. A full distirbution of ICU4C, such as from `brew`, is required. 

To build with brewed ICU:

```bash
PKG_CONFIG_PATH=/usr/local/opt/icu4c/lib/pkgconfig swift build
```

## Concepts

### Memory Management

