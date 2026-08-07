// swift-tools-version: 5.9
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
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.18.7") 
    ]
)
