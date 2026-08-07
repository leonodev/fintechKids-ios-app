
import ProjectDescription

public extension Scheme {
    /// Genera un esquema dedicado para ejecutar la App de Ejemplo de un módulo
    static func makeExampleScheme(for moduleName: String) -> Scheme {
        let exampleTargetName = "\(moduleName)Example"
        
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
