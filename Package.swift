// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DataStructures",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "DataStructures",
            targets: ["DataStructures"]
        ),
        .executable(name: "Example", targets: ["Example"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "DataStructures",
            dependencies: [],
            path: "Sources/DataStructures",
            swiftSettings: [
                .define("ENABLE_DEBUG", .when(configuration: .debug)),
            ]
        ),
        .target(
            name: "Example",
            dependencies: ["DataStructures"],
            path: "Sources/Example"
        ),
        .testTarget(
            name: "DataStructuresTests",
            dependencies: ["DataStructures"]
        ),
    ]
)
