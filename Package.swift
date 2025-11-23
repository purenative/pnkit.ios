// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PNKit",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        .library(
            name: "PNUIKit",
            targets: ["PNUIKit"]
        ),
        .library(
            name: "PNArch",
            targets: ["PNArch"]
        )
    ],
    targets: [
        .target(
            name: "PNUIKit",
            path: "PNUIKit"
        ),
        .target(
            name: "PNArch",
            path: "PNArch"
        ),
    ]
)
