//
//  ErrorView.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 8/1/26.
//

import SwiftUI


public struct ErrorView: View {
    var title: String
    var msnError: String
    var titleBtn: String
    var onActionPressed: (() -> Void)
    
    public init(title: String,
                msnError: String,
                titleBtn: String,
                onActionPressed: @escaping () -> Void
    ) {
        self.title = title
        self.msnError = msnError
        self.titleBtn = titleBtn
        self.onActionPressed = onActionPressed
    }
    
    public var body: some View {
        VStack {
            Spacer()
            
            Text(title)
                .foregroundStyle(FHKColor.lunarSand)
                .font(Font.PangramSans.bold(FHKSize.size32))
            Spacer()
            
            Text(msnError)
                .foregroundStyle(FHKColor.lunarSand.opacity(0.5))
                .font(Font.PangramSans.light(FHKSize.size20))
                .padding(.bottom, FHKSize.size20)
            
            LottieView(animationName: Lotties.errorUser,
                       loopMode: .loop,
                       contentMode: .scaleAspectFit)
            .frame(height: 150)
            .padding(.bottom, FHKSize.size40)
            
            Spacer()
            
            FHKButtonPrimary(title: titleBtn,
                             textColor: FHKColor.lunarSand.opacity(0.8),
                             state: .enabled,
                             mode: .glass(.clear),
                             action: {
                onActionPressed()
            })
            .padding()
        }
        .padding()
    }
}

#Preview {
    VStack {
        ErrorView(title: "Opppss...",
                  msnError: "Algo ha ido mal, inténtalo más tarde.",
                  titleBtn: "Entendido".uppercased(),
                  onActionPressed: {
            
        })
    }
    .background(FHKColor.indigo)
}
