// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SnakeGame",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "SnakeGame",
            targets: ["SnakeGame"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SnakeGame",
            dependencies: []
        ),
        .testTarget(
            name: "SnakeGameTests",
            dependencies: ["SnakeGame"]
        ),
    ]
)

