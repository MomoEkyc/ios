// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "MomoEkycSDK",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "MomoEkycSDK",
            targets: ["MomoEkycSDKWrapper"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/google/mlkit-ios.git", from: "6.0.0"),
        .package(url: "https://github.com/airbnb/lottie-ios.git", exact: "4.4.3")
    ],
    targets: [
        .binaryTarget(
            name: "MomoEkycSDKBinary",
            path: "MomoEkycSDK.xcframework"
        ),
        .target(
            name: "MomoEkycSDKWrapper",
            dependencies: [
                "MomoEkycSDKBinary",
                .product(name: "MLKitCore", package: "mlkit-ios"),
                .product(name: "FaceDetection", package: "mlkit-ios"),
                .product(name: "BarcodeScanning", package: "mlkit-ios"),
                .product(name: "TextRecognition", package: "mlkit-ios"),
                "lottie-ios"
            ],
            path: "Sources/MomoEkycSDKWrapper"
        )
    ]
)