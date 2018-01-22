# CIFKit

High-level Swift bindings for `COMCIFS/cif_api`, enabling CIF parsing, writing, and manipulation.

## Usage

CIFKit is currently only available through SPM (Swift Package Manager). Simply add to your dependencies:

```
.package(url: "https://github.com/xtallography/CIFKit", .upToNextMajor(from: "x.x.x"))
```

See [building details](##building) for linkage details: on macOS, you will likely need to override `PKG_CONFIG_PATH` to make a non-system distribution of `icu4c` available at compile-time.

## Building

In macOS build environments, the system provides `libicu`, but does not provide headers nor pkgconfig. A full distirbution of ICU4C, such as from `brew`, is required. 

To build with brewed ICU:

```
PKG_CONFIG_PATH=/usr/local/opt/icu4c/lib/pkgconfig swift build
```

