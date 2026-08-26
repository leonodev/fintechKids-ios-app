// swift-tools-version: 6.0
import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // productTypes: ["Alamofire": .framework,]
        productTypes: [:]
    )
#endif

let package = Package(
    name: "fintechKidsAppDependencies",
    dependencies: [
        .package(url: "https://github.com/airbnb/lottie-spm.git", from: "4.5.2"),
        .package(url: "https://github.com/apple/swift-algorithms.git", from: "1.2.1"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.18.7"),
        .package(url: "https://github.com/supabase/supabase-swift.git", from: "2.5.1"),
        .package(url: "https://github.com/leonodev/FLib-Utils.git", from: "1.0.2"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "12.6.0"),
        .package(url: "https://github.com/leonodev/FLib-Injections.git", from: "1.0.4"),
        .package(url: "https://github.com/leonodev/FLib-Storage.git", from: "1.0.6")
    ]
)
