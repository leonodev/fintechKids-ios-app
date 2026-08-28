import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "FintechHomeKids",
    options: .options(
        automaticSchemesOptions: .disabled // solo muesta los eschemas de main app y los example
    ),
    settings: .settings(
        configurations: [.dev, .qa, .prod]
    ),
    targets: [
        Target.coreModule(name: "FHKCore", dependencies: [
            .external(name: "FLibInjections"),
            .external(name: "FLibUtils"),
            .external(name: "FLibStorage")
        ]),
        Target.coreModule(name: "FHKDesignSystem", dependencies: [
            .target(name: "FHKCore"),
            .external(name: "Lottie"),
            .external(name: "Algorithms")
        ]),
        Target.domainModule(dependencies: [
            .target(name: "FHKCore")
        ]),
        Target.infraModule(name: "FHKInfrastructure", dependencies: [
            .external(name: "Supabase"),
            .external(name: "FirebaseAnalytics"),
            .external(name: "FirebaseFirestore"),
            .external(name: "FirebaseCrashlytics"),
            .external(name: "FirebaseMessaging"),
            .external(name: "FirebaseRemoteConfig")
        ]),
        Target.mainApp(dependencies: [
            .target(name: "FHKAuth"),
            .target(name: "FHKInfrastructure")
        ]),
        Target.coreModule(name: "FHKTesting", dependencies: [
            .target(name: "FHKCore"),
            .target(name: "FHKDomain")
        ])
    ]
    + Target.featureModule(name: "FHKAuth"),
    
    // Configuración explícita de Esquemas
    schemes: [
        .scheme(
            name: "FintechHomeKids",
            shared: true,
            buildAction: .buildAction(targets: ["FintechHomeKids"]),
            runAction: .runAction(configuration: .configuration("Dev"), executable: "FintechHomeKids")
        ),
        .scheme(
            name: "FHKAuthExample",
            shared: true,
            buildAction: .buildAction(targets: ["FHKAuthExample"]),
            runAction: .runAction(configuration: .configuration("Dev"), executable: "FHKAuthExample")
        )
    ]
)
