//
//  Project+Templates.swift
//  Manifests
//
//  Created by Fredy Leon on 4/9/26.
//

import ProjectDescription

public extension Project {
    static func makeApp(
        name: String,
        packages: [Package.Dependency] = [],
        baseLanguage: String = "en",
        targets: [[Target]],
        schemes: [Scheme] = []
    ) -> Project {
        return Project(
            name: name,
            options: .options(
                /// Desactiva los esquemas automáticos genéricos
                automaticSchemesOptions: .disabled,
                developmentRegion: baseLanguage
            ),
            packages: packages,
            settings: .settings(
                base: [
                    /// Desactiva la búsqueda de cabeceras Objective-C en módulos de Swift puro/
                    "DEFINES_MODULE": "NO",
                    
                    ///Evita que scripts de terceros lean o modifiquen archivos fuera de la carpeta del proyecto por temas de seguridad
                    "ENABLE_USER_SCRIPT_SANDBOXING": "YES",
                    
                    /// Genera autocompletado tipado para String Catalogs (.xcstrings) como Text(.welcomeTitle)
                    "LOCALIZED_STRING_CATALOG_GENERATE_SYMBOLS": "YES",
                    
                    /// Genera autocompletado tipado para imágenes y colores (.xcassets) (ej. Image(.logo) o Color(.primaryBlue))/
                    "ASSETCATALOG_COMPILER_GENERATE_ASSET_SYMBOLS": "YES",
                    
                    /// Sincroniza la versión del proyecto con la versión instalada de Xcode/
                    "LAST_UPGRADE_CHECK": "2650"
                ],
                configurations: [.dev, .qa, .prod],
                /// Indica a xcodebuild la configuración base por defecto
                defaultConfiguration: "Dev"
            ),
            targets: targets.flatMap { $0 },
            schemes: schemes
        )
    }
}
