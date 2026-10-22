//
//  FHKPreview.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 25/8/26.
//

import SwiftUI

public struct FHKPreview<Content: View>: View {
    private let content: () -> Content
    
    public init(
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content
    }
    
    public var body: some View {
        ZStack {
            // Fondo global que ignora safe areas
            FHKColor.indigo
                .ignoresSafeArea()
            
            // El contenido de la pantalla libre para gestionar sus propias safe areas
            content()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
