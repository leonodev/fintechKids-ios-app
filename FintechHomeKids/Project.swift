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
            .external(name: "Lottie")
        ]),
        Target.domainModule(dependencies: [
            .target(name: "FHKCore")
        ]),
        Target.infraModule(name: "InfraAuth", dependencies: [
            .external(name: "Supabase"),
            .external(name: "FirebaseAnalytics")
        ]),
        Target.mainApp(dependencies: [
            .target(name: "FHKAuth"),
            .target(name: "InfraAuth")
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
