//
//  FHKButtonPrimary.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 24/11/25.
//

import SwiftUI

public struct FHKButtonPrimary: View {
    public let title: String
    public var textColor: Color?
    public var appearance: FHKButtonAppearance
    public var identifier: String
    public var action: () -> Void
    
    public init(title: String,
                textColor: Color? = nil,
                style: FHKButtonComponent.Style = .filled,
                state: FHKButtonComponent.State = .enabled,
                variant: FHKButtonComponent.Variant = .simple,
                position: FHKButtonComponent.Position = .none,
                mode: FHKButtonComponent.Mode = .glass(.clear),
                identifier: String = "",
                action: @escaping () -> Void = {}) {
        self.title = title
        self.textColor = textColor
        appearance = FHKButtonAppearance(
            type: .primary,
            style: style,
            state: state,
            variant: variant,
            position: position,
            mode: mode
        )
        self.identifier = identifier
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(appearance.font)
                .foregroundColor(textColor ?? appearance.foregroundColor)
                .frame(maxWidth: .infinity)
                .frame(height: appearance.maxHeight)
                .background(backgroundView)
                .cornerRadius(30)
                .shadow(radius: 4, y: 2)
        }
        .disabled(appearance.state != .enabled)
        .buttonStyle(.plain)
        .accessibilityIdentifier(identifier)
    }

    @ViewBuilder
    private var backgroundView: some View {
        if case .glass(let glassVariant) = appearance.mode {
            if #available(iOS 26.0, *) {
                 Color.clear
                    .glassEffect(appearance.modeGlass(variant: glassVariant))
            } else {
                Color.white.opacity(0.2)
                    .background(.ultraThinMaterial)
            }
        } else {
            appearance.solidBackgroundColor()
        }
    }
}


#Preview {
    VStack {
        FHKButtonPrimary(title: "Button Primary",
                         textColor: nil,
                         state: .enabled,
                         mode: .glass(.clear),
                         action: {
            
        })
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background {
        Image.background
            .resizable()
            .aspectRatio(contentMode: .fill)
            .ignoresSafeArea()
    }
    .ignoresSafeArea()
}
