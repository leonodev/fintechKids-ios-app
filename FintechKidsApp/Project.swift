import ProjectDescription
import ProjectDescriptionHelpers

// Módules Core
let designSystemModuleCore = Target.module(
    name: "DesignSystem",
    category: "Core",
    hasTests: false,
    hasExample: true,
    dependencies: [
        .external(name: "Lottie"),
        .external(name: "Algorithms")
    ],
    testDependencies: [
        .external(name: "SnapshotTesting")
    ]
)

// Módules Features
let authModuleFeature = Target.module(name: "Auth", category: "Features")

let appTargets = [
    Target.app(
        name: "FintechKidsApp",
        dependencies: [
            .target(name: "DesignSystem"),
            .target(name: "Auth")
        ]
    )
]

let project = Project.makeApp(
    name: "FintechKidsApp",
    packages: [],
    targets: [
        appTargets,
        designSystemModuleCore,
        authModuleFeature
    ],
    schemes:
        Scheme.makeAppSchemes(appName: "FintechKidsApp") + [
            Scheme.makeExampleScheme(for: "DesignSystem")
        ]
)
