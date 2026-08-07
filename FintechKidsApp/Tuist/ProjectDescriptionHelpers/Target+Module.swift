import ProjectDescription

public extension Target {
    static var defaultSettings: Settings {
        .settings(base: [
            /// Desactiva la búsqueda de cabeceras Objective-C en módulos de Swift puro
            "DEFINES_MODULE": "NO",
            
            /// Evita que scripts de terceros lean o modifiquen archivos fuera de la carpeta del proyecto
            "ENABLE_USER_SCRIPT_SANDBOXING": "YES",
            
            /// Genera autocompletado tipado para String Catalogs (.xcstrings)
            "LOCALIZED_STRING_CATALOG_GENERATE_SYMBOLS": "YES",
            
            /// Genera autocompletado tipado para imágenes y colores (.xcassets)
            "ASSETCATALOG_COMPILER_GENERATE_ASSET_SYMBOLS": "YES",
            
            /// Silencia avisos de falta de símbolos en librerías estáticas
            "OTHER_LIBTOOLFLAGS": "-no_warning_for_no_symbols",
            
            /// Permite el uso de @testable import en los targets de pruebas
            "ENABLE_TESTABILITY": "YES"
        ])
    }

    /// Genera tanto el target del módulo de producción como su target de Unit Tests asociado.
    static func module(
        name: String,
        category: String = "Core",
        hasTests: Bool = true,
        hasTesting: Bool = false,
        hasExample: Bool = false,
        destinations: Destinations = .iOS,
        product: Product = .staticFramework,
        bundleIdPrefix: String = "com.fleon.fintechKidsApp",
        deploymentTarget: DeploymentTargets = .iOS("17.0"),
        dependencies: [TargetDependency] = [],
        testDependencies: [TargetDependency] = []
    ) -> [Target] {
        let basePath = "Targets/\(category)/\(name)"
        var targets: [Target] = []
        
        let mainTarget = Target.target(
            name: name,
            destinations: destinations,
            product: product,
            bundleId: "\(bundleIdPrefix).\(name.lowercased())",
            deploymentTargets: deploymentTarget,
            infoPlist: .default,
            sources: ["\(basePath)/Sources/**"],
            resources: ["\(basePath)/Resources/**"],
            dependencies: dependencies,
            settings: defaultSettings
        )
        targets.append(mainTarget)
        
        /// Target de Pruebas Unitarias
        if hasTests {
            let testTarget = Target.target(
                name: "\(name)Tests",
                destinations: destinations,
                product: .unitTests,
                bundleId: "\(bundleIdPrefix).\(name.lowercased()).tests",
                infoPlist: .default,
                sources: ["\(basePath)/Tests/**"],
                dependencies: [.target(name: name)] + testDependencies
            )
            targets.append(testTarget)
        }
        
        if hasTesting {
            targets.append(moduleTesting(for: name, category: category))
        }
        
        if hasExample {
            targets.append(moduleExample(for: name, category: category))
        }
        
        return targets
    }
    
    /// Target de tipo App con la configuración estándar del equipo.
    static func app(
        name: String,
        dependencies: [TargetDependency] = []
    ) -> Target {
        .target(
            name: name,
            destinations: .iOS,
            product: .app,
            bundleId: "$(PRODUCT_BUNDLE_IDENTIFIER)",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(with: [
                "CFBundleDisplayName": "$(APP_NAME)",
                "BASE_URL": "$(BASE_URL)",
                "UIBackgroundModes": ["remote-notification"],
                "UILaunchScreen": [:]
            ]),
            sources: ["Targets/\(name)/Sources/**"],
            resources: ["Targets/\(name)/Resources/**"],
            entitlements: .file(path: .relativeToRoot("Targets/\(name)/\(name).entitlements")),
            dependencies: dependencies,
            settings: .settings(
                base: defaultSettings.base.merging([
                    "ASSETCATALOG_COMPILER_APPICON_NAME": "$(APP_ICON_NAME)"
                ]) { $1 },
                configurations: [.dev, .qa, .prod]
            )
        )
    }

    /// Genera la App de Ejemplo aislada para probar el módulo de forma independiente.
    static func moduleExample(
        for moduleName: String,
        category: String = "Core",
        deploymentTarget: DeploymentTargets = .iOS("17.0"),
        dependencies: [TargetDependency] = []
    ) -> Target {
        let basePath = "Targets/\(category)/\(moduleName)"
        
        return .target(
            name: "\(moduleName)Example",
            destinations: .iOS,
            product: .app,
            bundleId: "$(PRODUCT_BUNDLE_IDENTIFIER).\(moduleName.lowercased())",
            deploymentTargets: deploymentTarget,
            infoPlist: .extendingDefault(with: [
                "CFBundleDisplayName": "\(moduleName) Example",
                "BASE_URL": "$(BASE_URL)",
                "UILaunchScreen": [:]
            ]),
            sources: ["\(basePath)/Example/Sources/**"],
            resources: ["\(basePath)/Resources/**"],
            dependencies: [.target(name: moduleName)] + dependencies,
            settings: .settings(
                base: defaultSettings.base,
                configurations: [.dev, .qa, .prod]
            )
        )
    }

    
    /// Target para compartir Mocks y Fakes entre Tests, Previews y Examples
    static func moduleTesting(
        for moduleName: String,
        category: String = "Core",
        deploymentTarget: DeploymentTargets = .iOS("17.0"),
        dependencies: [TargetDependency] = []
    ) -> Target {
        let basePath = "Targets/\(category)/\(moduleName)"
        return .target(
            name: "\(moduleName)Testing",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.fleon.fintechKidsApp.\(moduleName.lowercased()).testing",
            deploymentTargets: deploymentTarget,
            infoPlist: .default,
            sources: ["\(basePath)/Testing/Sources/**"],
            dependencies: [
                .target(name: moduleName)
            ] + dependencies,
            settings: defaultSettings
        )
    }
}
