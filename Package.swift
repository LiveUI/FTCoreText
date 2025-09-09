// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "FTCoreText",
    platforms: [
        .iOS(.v13), .macOS(.v10_15)
    ],
    products: [
        .library(name: "FTCoreText", targets: ["FTCoreText"])
    ],
    targets: [
        .target(name: "FTCoreText", path: "Sources/FTCoreText")
    ]
)

