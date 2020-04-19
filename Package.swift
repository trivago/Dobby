// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Dobby",
    products: [
        .library(name: "Dobby", targets: ["Dobby"])
    ],
    targets: [
        .target(name: "Dobby", path: "./Dobby"),
        .testTarget(name: "DobbyTests", dependencies: ["Dobby"], path: "./DobbyTests")
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
