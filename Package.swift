// swift-tools-version:5.4.0

import PackageDescription

let package = Package(
    name: "MXParallaxHeader",
    platforms: [ .iOS(.v10)],
    products: [
        .library(
            name: "MXParallaxHeader",
            targets: ["MXParallaxHeader"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "MXParallaxHeader",
            dependencies: [],
            path: "MXParallaxHeader",
            publicHeadersPath: ".")
    ]
)