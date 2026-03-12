// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-image",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "WarpMetal",
            targets: ["WarpMetal"]
        ),

        .library(
            name: "WarpTransform",
            targets: ["WarpTransform"]
        ),

        .library(
            name: "WarpSwiftUI",
            targets: ["WarpSwiftUI"]
        ),

    ],

    dependencies: [
        .package(url: "https://github.com/vitali-kurlovich/swift-ui.git", from: "0.0.3"),
        .package(url: "https://github.com/vitali-kurlovich/swift-mathkit.git", from: "0.0.2"),
        .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.1.0"),
    ],

    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "WarpMetal",
            dependencies: [
                "WarpTransform",
                .product(name: "VisualEffects", package: "swift-ui"),
                .product(name: "MathKit", package: "swift-mathkit"),
            ],
            resources: [
                .process("FreeDistort/Metal/"),
            ]
        ),

        .target(
            name: "WarpTransform",
            dependencies: [
                .product(name: "MathKit", package: "swift-mathkit"),
                .product(name: "MathTransform", package: "swift-mathkit"),
            ]
        ),

        .target(
            name: "WarpSwiftUI",
            dependencies: [
                "WarpMetal",
                .product(name: "VisualEffects", package: "swift-ui"),
                .product(name: "MathKit", package: "swift-mathkit"),
                .product(name: "MathTransform", package: "swift-mathkit"),
            ]
        ),

        .testTarget(
            name: "WarpTests",
            dependencies: [
                "WarpTransform",
                .product(name: "MathKit", package: "swift-mathkit"),
                .product(name: "MathTransform", package: "swift-mathkit"),
            ]
        ),
    ]
)
