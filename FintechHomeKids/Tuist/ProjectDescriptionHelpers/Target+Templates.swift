import ProjectDescription

public extension Target {
    
    // Configuración base de Settings
    static var defaultSettings: Settings {
        .settings(base: [
            /// Desactiva la búsqueda de cabeceras Objective-C en módulos de Swift puro
            "DEFINES_MODULE": "YES",
            
            /// Evita que scripts de terceros lean o modifiquen archivos fuera de la carpeta del proyecto
            "ENABLE_USER_SCRIPT_SANDBOXING": "YES",
            
            /// Genera autocompletado tipado para String Catalogs (.xcstrings)
            "LOCALIZED_STRING_CATALOG_GENERATE_SYMBOLS": "YES",
            
            /// Genera autocompletado tipado para imágenes y colores (.xcassets)
            "ASSETCATALOG_COMPILER_GENERATE_ASSET_SYMBOLS": "YES",
            
            /// Silencia avisos de falta de símbolos en librerías estáticas
            "OTHER_LIBTOOLFLAGS": "-no_warning_for_no_symbols",
            
            /// Permite el uso de @testable import en los targets de pruebas
            "ENABLE_TESTABILITY": "YES",
            
            /// Todos los módulos heredarán Swift 6 por defecto
            "SWIFT_VERSION": "6.0",
            
            "OTHER_LDFLAGS": .array(["$(inherited)", "-ObjC"])
        ])
    }

    // 1. Target Core / Base (Inyecciones, Utilidades, Storage)
    static func coreModule(name: String, dependencies: [TargetDependency] = []) -> Target {
        .target(
            name: name,
            destinations: .iOS,
            product: .framework,
            bundleId: "com.fleon.fintechHomeKids.\(name.lowercased())",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Targets/FHKCore/\(name)/Sources/**"],
            resources: ["Targets/FHKCore/\(name)/Resources/**"],
            dependencies: dependencies,
            settings: defaultSettings
        )
    }

    // 2. Target Domain (Código Swift puro: Protocolos, UseCases, Entidades)
    static func domainModule(dependencies: [TargetDependency] = []) -> Target {
        .target(
            name: "FHKDomain",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.fleon.fintechHomeKids.domain",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Targets/FHKDomain/Sources/**"],
            dependencies: dependencies,
            settings: defaultSettings
        )
    }

    // 3. Targets de Features (Vistas, ViewModels, Previews). NO reciben Infraestructura.
    static func featureModule(
        name: String,
        hasExample: Bool = true,
        dependencies: [TargetDependency] = []
    ) -> [Target] {
        let basePath = "Targets/Features/\(name)"
        var targets: [Target] = []

        // Módulo principal de la Feature (.framework para Previews instantáneas)
        let mainTarget = Target.target(
            name: name,
            destinations: .iOS,
            product: .framework,
            bundleId: "com.fleon.fintechHomeKids.\(name.lowercased())",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["\(basePath)/Sources/**"],
            resources: ["\(basePath)/Resources/**"],
            dependencies: [
                .target(name: "FHKDomain"),
                .target(name: "FHKDesignSystem"),
                .target(name: "FHKCore"),
                .target(name: "FHKTesting")
            ] + dependencies,
            settings: defaultSettings
        )
        targets.append(mainTarget)

        // App de Ejemplo aislada para desarrollo individual
        if hasExample {
            let exampleTarget = Target.target(
                name: "\(name)Example",
                destinations: .iOS,
                product: .app,
                bundleId: "com.fleon.fintechHomeKids.\(name.lowercased()).example",
                deploymentTargets: .iOS("17.0"),
                infoPlist: .extendingDefault(with: [
                    "CFBundleDisplayName": "\(name) Example",
                    "UILaunchScreen": [:]
                ]),
                sources: ["\(basePath)/Example/Sources/**"],
                dependencies: [.target(name: name)],
                settings: defaultSettings
            )
            targets.append(exampleTarget)
        }

        return targets
    }

    // 4. Target Infrastructure (Firebase, Supabase, SDKs pesados)
    static func infraModule(name: String, dependencies: [TargetDependency] = []) -> Target {
        .target(
            name: name,
            destinations: .iOS,
            product: .framework,
            bundleId: "com.fleon.fintechHomeKids.infra.\(name.lowercased())",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Targets/FHKInfrastructure/\(name)/Sources/**"],
            dependencies: [
                .target(name: "FHKDomain"),
                .target(name: "FHKCore")
            ] + dependencies,
            settings: defaultSettings
        )
    }

    // 5. App Principal (Ensamblador de la DI)
    static func mainApp(dependencies: [TargetDependency] = []) -> Target {
        .target(
            name: "FintechHomeKids",
            destinations: .iOS,
            product: .app,
            bundleId: "com.fleon.fintechHomeKids",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(with: [
                "CFBundleDisplayName": "FintechHomeKids",
                "UILaunchScreen": [:]
            ]),
            sources: ["Targets/FintechHomeKids/Sources/**"],
            resources: ["Targets/FintechHomeKids/Resources/**"],
            dependencies: dependencies,
            settings: defaultSettings
        )
    }
}
