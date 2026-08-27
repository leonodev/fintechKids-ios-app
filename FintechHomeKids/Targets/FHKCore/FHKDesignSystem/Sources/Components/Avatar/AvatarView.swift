//
//  AvatarView.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 20/1/26.
//
import SwiftUI

public struct AvatarView: View {
    private enum AvatarSource {
        case image(Image)
        case text(String)
    }

    private let source: AvatarSource
    private let size: CGFloat
    
    // Inicializador para Imagen
    public init(image: Image,
                size: CGFloat = FHKSize.size60
    ) {
        self.source = .image(image)
        self.size = size
    }
    
    // Inicializador para String (Iniciales)
    public init(name: String,
                size: CGFloat = FHKSize.size60
    ) {
        let initials = String(name.prefix(2)).uppercased()
        self.source = .text(initials)
        self.size = size
    }

    public var body: some View {
        content
            .frame(width: size, height: size)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(FHKColor.lunarSand.opacity(0.8), lineWidth: 3)
            )
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }

    @ViewBuilder
    private var content: some View {
        switch source {
        case .image(let image):
            image
                .resizable()
                .scaledToFill()
        case .text(let initials):
            ZStack {
                Color.purple.opacity(0.3)
                Text(initials)
                    .font(.system(size: size * 0.4, weight: .bold, design: .rounded))
                    .foregroundColor(FHKColor.lunarSand)
            }
        }
    }
}


#Preview {
    VStack {
        AvatarView(image: AvatarType.boy_1.image)
        AvatarView(name: "Fredy Leon")
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(FHKColor.indigo)
}
