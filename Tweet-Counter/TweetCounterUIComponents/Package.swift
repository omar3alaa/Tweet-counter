// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TweetCounterUIComponents",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "TweetCounterUIComponents",
            targets: ["TweetCounterUIComponents"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.5.0"),
        .package(name: "TweetCounterUtilities", path: "../TweetCounterUtilities")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "TweetCounterUIComponents",
            dependencies: ["TweetCounterUtilities",
                           "RxSwift",
                           .product(name: "RxCocoa", package: "RxSwift")],
            resources: [
                .process("Resources"),
                .process("Core/Custom views/Tweet counter/Views/TweetCounterView.xib")
            ]),
        .testTarget(
            name: "TweetCounterUIComponentsTests",
            dependencies: ["TweetCounterUIComponents"]),
    ]
)
