
import ProjectDescription

public extension SettingsDictionary {
    static var releasePentestingSettings: SettingsDictionary {
        [
            /// Habilita el motor de postprocesado de ofuscacion del compilador
            "DEPLOYMENT_POSTPROCESSING": "YES",
            
            /// Elimina la tabla de símbolos del binario de la app. Los nombres de las clases, funciones y variables privadas desaparecerán al descompilar.
            "STRIP_INSTALLED_PRODUCT": "YES",
            
            /// Aplica el mismo borrado de símbolos a los frameworks de terceros que copies en la app.
            "COPY_PHASE_STRIP": "YES",
            
            /// Nivel de agresividad del borrado: 'non-global' borra los símbolos internos pero mantiene lo estrictamente necesario (símbolos globales) para que iOS cargue la app./
            "STRIP_STYLE": "non-global",
            
            /// Extrae los símbolos eliminados a un archivo externo (.dSYM) para que Crashlytics pueda leer los crashes, manteniendo el binario que va al App Store 100% ofuscado./
            "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
            
            /// aplicar el ASLR correctamente (evita que Ghidra pueda predecir direcciones de memoria)/
            "GCC_DYNAMIC_NO_PIC": "NO",
            
            /// Evita que manipulen la dirección de retorno en la pila haciendo estallar la app si detecta memoria sobrescrita./
            "OTHER_CFLAGS": ["-fstack-protector-strong", "-fPIE"],
            
            /// Elimina código huérfano del binario (Ghidra verá solo lo necesario)/
            "DEAD_CODE_STRIPPING": "YES",
            
            /// Inhabilita la inyección de librerías dylib arbitrarias/
            "ENABLE_BITCODE": "NO"
        ]
    }

    static var debugPentestingSettings: SettingsDictionary {
        [
            "DEPLOYMENT_POSTPROCESSING": "NO",
            "STRIP_INSTALLED_PRODUCT": "NO",
            "COPY_PHASE_STRIP": "NO",
            "DEBUG_INFORMATION_FORMAT": "dwarf"
        ]
    }
}

public extension Configuration {
    static var dev: Configuration {
        .debug(
            name: "Dev",
            settings: .debugPentestingSettings,
            xcconfig: .relativeToRoot("Configurations/Dev.xcconfig")
        )
    }

    static var qa: Configuration {
        .release(
            name: "QA",
            settings: .releasePentestingSettings,
            xcconfig: .relativeToRoot("Configurations/QA.xcconfig")
        )
    }

    static var prod: Configuration {
        .release(
            name: "Prod",
            settings: .releasePentestingSettings,
            xcconfig: .relativeToRoot("Configurations/Prod.xcconfig")
        )
    }
}
