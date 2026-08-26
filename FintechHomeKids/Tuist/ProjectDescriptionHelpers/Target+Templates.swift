import ProjectDescription

public extension Target {
    
    // Configuración base con los 3 ambientes globales
    static var defaultSettings: Settings {
        .settings(
            base: [
                "DEFINES_MODULE": "YES",
                "ENABLE_USER_SCRIPT_SANDBOXING": "YES",
                "LOCALIZED_STRING_CATALOG_GENERATE_SYMBOLS": "YES",
                "ASSETCATALOG_COMPILER_GENERATE_ASSET_SYMBOLS": "YES",
                "OTHER_LIBTOOLFLAGS": "-no_warning_for_no_symbols",
                "ENABLE_TESTABILITY": "YES",
                "SWIFT_VERSION": "6.0",
                "OTHER_LDFLAGS": .array(["$(inherited)", "-ObjC"])
            ],
            configurations: [.dev, .qa, .prod] // Todos los targets deben conocer Dev, QA y Prod
        )
    }

    // 1. Core
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

    // 2. Domain
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

    // 3. Features
    static func featureModule(
        name: String,
        hasExample: Bool = true,
        dependencies: [TargetDependency] = []
    ) -> [Target] {
        let basePath = "Targets/Features/\(name)"
        var targets: [Target] = []

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

        if hasExample {
            let exampleTarget = Target.target(
                name: "\(name)Example",
                destinations: .iOS,
                product: .app,
                bundleId: "com.fleon.fintechHomeKids.\(name.lowercased()).example",
                deploymentTargets: .iOS("17.0"),
                infoPlist: .extendingDefault(with: [
                    "BASE_URL": "$(BASE_URL)",
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

    // 4. Infrastructure
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

    // 5. App Principal
    static func mainApp(dependencies: [TargetDependency] = []) -> Target {
        .target(
            name: "FintechHomeKids",
            destinations: .iOS,
            product: .app,
            bundleId: "$(PRODUCT_BUNDLE_IDENTIFIER)",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(with: [
                "CFBundleDisplayName": "$(APP_NAME)",
                "BASE_URL": "$(BASE_URL)",
                "UILaunchScreen": [:]
            ]),
            sources: ["Targets/FintechHomeKids/Sources/**"],
            resources: [
                "Targets/FintechHomeKids/Resources/**",
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
}
