//
//  PopupContainer.swift
//  fintechKids
//
//  Created by Fredy Leon on 2/3/26.
//

import SwiftUI
import FHKDesignSystem

public struct FHKPopupContainer: View {
    let content: AnyView
    let dismiss: () -> Void

    public var body: some View {
        ZStack {
            VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
                .ignoresSafeArea()
                .onTapGesture { dismiss() }

            VStack(spacing: FHKSpace.space20) {
                content
            }
            .padding(FHKSpace.space24)
            .background(
                Color.black.opacity(0.1)
            )
            .cornerRadius(FHKSize.size24)
            .overlay(
                RoundedRectangle(cornerRadius: FHKSize.size24)
                    .stroke(FHKColor.lunarSand.opacity(0.6), lineWidth: 1.5)
            )
            .padding(.horizontal, FHKSpace.space28)
        }
    }
}
