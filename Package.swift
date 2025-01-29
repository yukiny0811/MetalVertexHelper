// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "MetalVertexHelper",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .visionOS(.v2),
    ],
    products: [
        .library(
            name: "MetalVertexHelper",
            targets: ["MetalVertexHelper"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", exact: "600.0.1"),
    ],
    targets: [
        .macro(
            name: "MetalVertexHelperMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(
            name: "MetalVertexHelper",
            dependencies: [
                "MetalVertexHelperMacros",
            ]
        ),
        .testTarget(
            name: "MetalVertexHelperTests",
            dependencies: [
                "MetalVertexHelper"
            ]
        )
    ]
)
