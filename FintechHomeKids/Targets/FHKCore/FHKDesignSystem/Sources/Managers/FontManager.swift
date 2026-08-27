//
//  FontManager.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 22/11/25.
//

//
//  FontManager.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 22/11/25.
//

import SwiftUI
import CoreText

@MainActor
public final class FontManager {
    private static var fontsRegistered = false
    
    public static func registerFonts() {
        // Evitar registro duplicado
        guard !fontsRegistered else {
            print("⚠️ Fuentes ya registradas, omitiendo...")
            return
        }
        
        if let resourceURLs = Bundle.module.urls(forResourcesWithExtension: "otf", subdirectory: nil) {
            for url in resourceURLs {
                
                let fontName = url.deletingPathExtension().lastPathComponent
                registerFont(fontName: fontName, fontExtension: "otf")
            }
        } else {
            print("❌ No se encontraron archivos .otf en el bundle")
        }
        
        fontsRegistered = true
        print("✅ Registro de fuentes completado")
    }
    
    private static func registerFont(fontName: String, fontExtension: String) {
        #if os(iOS)
        let bundle = Bundle.module
        
        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension) else {
            print("   ❌ No se encontró el archivo: \(fontName).\(fontExtension)")
            return
        }
        
        guard let fontDataProvider = CGDataProvider(url: fontURL as CFURL) else {
            print("   ❌ Error creando data provider para: \(fontName)")
            return
        }
        
        guard let font = CGFont(fontDataProvider) else {
            print("   ❌ Error creando CGFont para: \(fontName)")
            return
        }
        
        var error: Unmanaged<CFError>?
        if CTFontManagerRegisterGraphicsFont(font, &error) {
            
            // if let postScriptName = font.postScriptName as String? {
               // print("   🏷️ Nombre PostScript real: \(postScriptName)")
           // }
        } else {
            let errorDescription = error?.takeUnretainedValue().localizedDescription ?? "Error desconocido"
            print("   ❌ Error registrando fuente \(fontName): \(errorDescription)")
        }
        #endif
    }
    
    // Método para verificar y registrar si es necesario
    public static func registerFontsIfNeeded() {
        if !fontsRegistered {
            registerFonts()
        }
    }
}
