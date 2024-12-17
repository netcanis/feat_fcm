// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "feat_fcm",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(name: "feat_fcm", targets: ["feat_fcm"]),
    ],
    dependencies: [
        // Define external dependencies here using GitHub URLs or package names.
        .package(url: "https://github.com/netcanis/feat_apns.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: "11.5.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "feat_fcm",
            dependencies: [
                .product(name: "feat_apns", package: "feat_apns"),
                .product(name: "FirebaseMessaging", package: "firebase-ios-sdk"),
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "feat_fcmTests",
            dependencies: [
                "feat_fcm"
            ],
            path: "Tests"
        ),
    ]
)
