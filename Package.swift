// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "xsh",
    platforms: [
      .macOS(.v13)
      
    ],
    dependencies: [
         // Add Swift Testing as a package dependency
        .package(url: "https://github.com/swiftlang/swift-testing.git", from: "0.10.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
          name: "xsh",
          path: "Sources"),
        
        .testTarget(
          name: "xshTesting",
          dependencies: [
            "xsh",
            .product(name:"Testing" , package:"swift-testing" )
          ],
          path: "Tests/xshTests/"
        ),
        
    ]
)
