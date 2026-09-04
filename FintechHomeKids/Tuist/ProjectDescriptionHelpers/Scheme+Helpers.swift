//
//  Scheme+Helpers.swift
//  Manifests
//
//  Created by Fredy Leon on 4/9/26.
//

import ProjectDescription

public extension Scheme {
    /// Schemes oficiales de la App principal
    static func makeSchemes(appName: String) -> [Scheme] {
        return ["Dev", "QA", "Prod"].map { env in
            .scheme(
                name: "\(appName)-\(env)",
                shared: true,
                buildAction: .buildAction(targets: [.target(appName)]),
                runAction: .runAction(
                    configuration: .configuration(env),
                    executable: .executable(.target(appName))
                ),
                archiveAction: .archiveAction(configuration: .configuration(env)),
                profileAction: .profileAction(
                    configuration: .configuration(env),
                    executable: .executable(.target(appName))
                ),
                analyzeAction: .analyzeAction(configuration: .configuration(env))
            )
        }
    }
    
    /// Genera un esquema dedicado para ejecutar la App de Ejemplo de un módulo
    static func makeSchemeExample(for moduleName: String) -> Scheme {
        let exampleTargetName = "\(moduleName)"
        
        return Scheme.scheme(
            name: exampleTargetName,
            shared: true,
            buildAction: .buildAction(targets: [.target(exampleTargetName)]),
            runAction: .runAction(
                configuration: "Dev",
                executable: .executable(.target(exampleTargetName))
            ),
            archiveAction: .archiveAction(configuration: "Dev"),
            profileAction: .profileAction(
                configuration: "Dev",
                executable: .executable(.target(exampleTargetName))
            ),
            analyzeAction: .analyzeAction(configuration: "Dev")
        )
    }
}
