import ProjectDescription
import ProjectDescriptionHelpers

// MARK: - App Principal
let appTarget = Target.app(
    name: "FintechHomeKids",
    dependencies: [
        .target(name: "FHKAuth"),
        .target(name: "FHKInfrastructure"),
        .target(name: "FHKCore")
    ]
)

// MARK: - Core, Design System & Testing
let coreTarget = Target.module(
    name: "FHKCore",
    path: "Targets/FHKCore",
    hasTests: false,
    dependencies: [
        .external(name: "FLibInjections"),
        .external(name: "FLibUtils"),
        .external(name: "FLibStorage")
    ]
)

let designSystemTarget = Target.module(
    name: "FHKDesignSystem",
    path: "Targets/FHKCore",
    hasTests: false,
    hasExample: true,
    dependencies: [
        .target(name: "FHKCore"),
        .target(name: "FHKTesting"),
        .external(name: "Lottie"),
        .external(name: "Algorithms")
    ]
)

let testingTarget = Target.module(
    name: "FHKTesting",
    path: "Targets/FHKCore",
    hasTests: false,
    dependencies: [
        .target(name: "FHKCore"),
        .target(name: "FHKDomain")
    ]
)

// MARK: - Domain
let domainTarget = Target.module(
    name: "FHKDomain",
    hasTests: false,
    dependencies: [
        .target(name: "FHKCore")
    ]
)

// MARK: - Infrastructure
let infrastructureTarget = Target.module(
    name: "FHKInfrastructure",
    hasTests: false,
    dependencies: [
        .target(name: "FHKDomain"),
        .target(name: "FHKCore"),
        .external(name: "Supabase"),
        .external(name: "FirebaseAnalytics"),
        .external(name: "FirebaseFirestore"),
        .external(name: "FirebaseCrashlytics"),
        .external(name: "FirebaseMessaging"),
        .external(name: "FirebaseRemoteConfig")
    ]
)

// MARK: - Features
let authFeatureTarget = Target.module(
    name: "FHKAuth",
    path: "Targets/Features",
    hasTests: true,
    hasExample: true,
    dependencies: [
        .target(name: "FHKDomain"),
        .target(name: "FHKDesignSystem"),
        .target(name: "FHKCore")
    ]
)

// MARK: - Project Assembly
let project = Project.makeApp(
    name: "FintechHomeKids",
    targets: [
        [appTarget],
        coreTarget,
        designSystemTarget,
        testingTarget,
        domainTarget,
        infrastructureTarget,
        authFeatureTarget
    ],
    schemes: Scheme.makeSchemes(appName: "FintechHomeKids") + [
        Scheme.makeSchemeExample(for: "FHKDesignSystemExample"),
        Scheme.makeSchemeExample(for: "FHKAuthExample")
    ]
)
