//
//  FHKContainer.swift
//  fintechKids
//
//  Created by Fredy Leon on 29/12/25.
//
import SwiftUI
import FHKInjections
import FHKDesignSystem

public struct ScreenContainer<Content: View>: View {
    private let content: () -> Content
    private let showNavigationBar: Bool
    private let title: String?
    private let backgroundImage: Image?

    public init(
        title: String? = nil,
        showNavigationBar: Bool = true,
        backgroundImage: Image? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.showNavigationBar = showNavigationBar
        self.backgroundImage = backgroundImage
        self.content = content
    }
    
    public var body: some View {
        GeometryReader { geometry in // <--- Usamos GeometryReader para saber el tamaño exacto del dispositivo
            ZStack {
                // Fondo Base: Degradado
                LinearGradient(
                    stops: [
                        .init(color: FHKColor.indigo, location: 0.1),
                        .init(color: .indigo, location: 0.9)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // Fondo Imagen corregido
                if let backgroundImage = backgroundImage {
                    backgroundImage
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        // Forzamos a la imagen a medir exactamente lo mismo que la pantalla del iPhone
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped() // <--- Truco Clave: Recorta todo lo que se desborde para que no empuje las vistas
                        .ignoresSafeArea()
                }
                
                // Contenido de la pantalla
                content()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .observeLanguage()
            }
        }
        .navigationBarHidden(!showNavigationBar)
        .navigationTitle(title ?? "")
        .navigationBarTitleDisplayMode(.inline)
    }
}
