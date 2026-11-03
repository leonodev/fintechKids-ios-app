//
//  CardView.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 12/3/26.
//

import SwiftUI

public struct CardView<Content: View, T>: View {
    let content: Content
    let data: T?
    let action: (T?) -> Void
    let isSelected: Bool

    public init(data: T,
                isSelected: Bool = false,
                action: @escaping (T?) -> Void,
                @ViewBuilder content: () -> Content
    ) {
        self.data = data
        self.isSelected = isSelected
        self.action = action
        self.content = content()
    }

    public init(isSelected: Bool = false,
                action: @escaping (T?) -> Void,
                @ViewBuilder content: () -> Content
    ) where T == Any {
        self.data = nil
        self.isSelected = isSelected
        self.action = action
        self.content = content()
    }

    public var body: some View {
        VStack {
            content
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [FHKColor.indigo.opacity(0.5), FHKColor.purpleBackground.opacity(0.7)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(isSelected ? FHKColor.fuchsiaPink : Color.clear, lineWidth: 2)
        )
        .onTapGesture {
            action(data)
        }
    }
}

#Preview {
    VStack {
        CardView { _ in
            print("Navegando al perfil del usuario: ")
        } content: {
            HStack {
                // Content Here
            }
            .frame(height: 100)
        }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.white)
}
