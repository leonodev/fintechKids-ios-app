import ProjectDescription

public extension Target {

    // MARK: - Configuración Base

    static var defaultSettings: Settings {
        .settings(
            base: [
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
            ],
            configurations: [.dev, .qa, .prod]
        )
    }

    // MARK: - Builder Genérico de Módulos

    static func module(
        name: String,
        path: String = "Targets",
        hasTests: Bool = true,
        hasExample: Bool = false,
        destinations: Destinations = .iOS,
        product: Product = .staticFramework,
        bundleIdPrefix: String = "com.fleon.fintechHomeKids",
        deploymentTarget: DeploymentTargets = .iOS("17.0"),
        dependencies: [TargetDependency] = [],
        testDependencies: [TargetDependency] = [.target(name: "FHKTesting")]
    ) -> [Target] {
        let basePath = "\(path)/\(name)"
        var targets: [Target] = []

        // 1. Target Principal
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

        // 2. Target de Tests
        if hasTests {
            let testTarget = Target.target(
                name: "\(name)Tests",
                destinations: destinations,
                product: .unitTests,
                bundleId: "\(bundleIdPrefix).\(name.lowercased()).tests",
                deploymentTargets: deploymentTarget,
                infoPlist: .default,
                sources: ["\(basePath)/Tests/**"],
                dependencies: [.target(name: name)] + testDependencies,
                settings: defaultSettings
            )
            targets.append(testTarget)
        }

        // 3. Target de App de Ejemplo
        if hasExample {
            targets.append(
                moduleExample(
                    for: name,
                    basePath: basePath,
                    bundleIdPrefix: bundleIdPrefix,
                    deploymentTarget: deploymentTarget,
                    dependencies: dependencies
                )
            )
        }

        return targets
    }

    // MARK: - App Principal

    static func app(
        name: String = "FintechHomeKids",
        bundleId: String = "$(PRODUCT_BUNDLE_IDENTIFIER)",
        deploymentTarget: DeploymentTargets = .iOS("17.0"),
        dependencies: [TargetDependency] = []
    ) -> Target {
        .target(
            name: name,
            destinations: .iOS,
            product: .app,
            bundleId: bundleId,
            deploymentTargets: deploymentTarget,
            infoPlist: .extendingDefault(with: [
                "CFBundleDisplayName": "$(APP_NAME)",
                "BASE_URL": "$(BASE_URL)",
                "UILaunchScreen": [:]
            ]),
            sources: ["Targets/\(name)/Sources/**"],
            resources: [
                "Targets/\(name)/Resources/**",
                .glob(pattern: .relativeToRoot("GoogleService-Info.plist"))
            ],
            dependencies: dependencies,
            settings: .settings(
                base: defaultSettings.base.merging([
                    "ASSETCATALOG_COMPILER_APPICON_NAME": "$(APP_ICON_NAME)"
                ]) { $1 },
                configurations: [.dev, .qa, .prod]
            )
        )
    }

    // MARK: - Helper Privado para Apps de Ejemplo

    private static func moduleExample(
        for moduleName: String,
        basePath: String,
        bundleIdPrefix: String,
        deploymentTarget: DeploymentTargets,
        dependencies: [TargetDependency]
    ) -> Target {
        .target(
            name: "\(moduleName)Example",
            destinations: .iOS,
            product: .app,
            bundleId: "\(bundleIdPrefix).\(moduleName.lowercased()).example",
            deploymentTargets: deploymentTarget,
            infoPlist: .extendingDefault(with: [
                "CFBundleDisplayName": "\(moduleName) Example",
                "BASE_URL": "$(BASE_URL)",
                "UILaunchScreen": [:]
            ]),
            sources: ["\(basePath)/Example/Sources/**"],
            resources: [
                "\(basePath)/Resources/**",
                /// Exclusivo de la Micro-App (AppIcon)
                "\(basePath)/Example/Resources/**",
                .glob(pattern: .relativeToRoot("GoogleService-Info.plist"))
            ],
            dependencies: [.target(name: moduleName)] + dependencies,
            settings: defaultSettings
        )
    }
}
