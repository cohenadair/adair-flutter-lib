// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "adair_install_attribution",
    platforms: [
        // Must not exceed the lowest Runner target of any app that depends on
        // adair_install_attribution (currently all at 15.6).
        .iOS("15.6")
    ],
    products: [
        .library(name: "adair-install-attribution", targets: ["adair_install_attribution"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "adair_install_attribution",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ]
        )
    ]
)
