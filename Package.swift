// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Dobby",
    products: [
        .library(name: "Dobby", targets: ["Dobby"])
    ],
    targets: [
        .target(name: "Dobby", dependencies: [], path: "./Dobby"),
    ]
)

