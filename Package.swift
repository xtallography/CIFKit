// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CIFKit",
    products: [
        .library(
            name: "CIFKit",
            targets: ["CIFKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/xtallography/Swift-CCIF", .upToNextMajor(from: "0.4.2"))
    ],
    targets: [
        .target(
            name: "CIFKit",
            dependencies: []),
        .testTarget(
            name: "CIFKitTests",
            dependencies: ["CIFKit"]),
    ]
)
