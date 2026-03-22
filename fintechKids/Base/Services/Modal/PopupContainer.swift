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

            ZStack(alignment: .topTrailing) {
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
                
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 45))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(FHKColor.lunarSand)
                        .padding(FHKSpace.space12)
                })
                .padding(.trailing, -25)
                .padding(.top, -30)
            }
            .padding(.horizontal, FHKSpace.space28)
        }
    }
}
