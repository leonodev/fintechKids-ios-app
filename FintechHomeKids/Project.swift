import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "FintechHomeKids",
    targets: [
        // Capa Base
        Target.coreModule(name: "FHKCore", dependencies: [
            .external(name: "FLibInjections"),
            .external(name: "FLibUtils"),
            .external(name: "FLibStorage")
        ]),
        Target.coreModule(name: "FHKDesignSystem", dependencies: [
            .target(name: "FHKCore"),
            .external(name: "Lottie")
        ]),
        
        // Capa Dominio
        Target.domainModule(dependencies: [
            .target(name: "FHKCore")
        ]),
        
        // Capa Infraestructura
        Target.infraModule(name: "InfraAuth", dependencies: [
            .external(name: "Supabase"),
            .external(name: "FirebaseAnalytics")
        ]),
        
        // App Principal
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
            runAction: .runAction(executable: "FintechHomeKids")
        ),
        .scheme(
            name: "FHKAuthExample",
            shared: true,
            buildAction: .buildAction(targets: ["FHKAuthExample"]),
            runAction: .runAction(executable: "FHKAuthExample")
        )
    ]
)
