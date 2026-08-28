// swift-tools-version: 6.0
import PackageDescription

#if TUIST
import ProjectDescription
import ProjectDescriptionHelpers

let packageSettings = PackageSettings(
    productTypes: [:],
    /// Al asignar baseSettings Tuist generará los proyectos de todas las dependencias SPM con las configuraciones Dev, QA y Prod, ya que los FHK solo tiene Debug y Release
    baseSettings: .settings(
        configurations: [
            .dev,
            .qa,
            .prod
        ]
    )
)
#endif

let package = Package(
    name: "fintechKidsAppDependencies",
    dependencies: [
        .package(url: "https://github.com/airbnb/lottie-spm.git", from: "4.5.2"),
        .package(url: "https://github.com/apple/swift-algorithms.git", from: "1.2.1"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.18.7"),
        .package(url: "https://github.com/supabase/supabase-swift.git", from: "2.5.1"),
        .package(url: "https://github.com/leonodev/FLib-Utils.git", from: "1.0.3"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "12.6.0"),
        .package(url: "https://github.com/leonodev/FLib-Injections.git", from: "1.0.6"),
        .package(url: "https://github.com/leonodev/FLib-Storage.git", from: "1.0.6")
    ]
)
