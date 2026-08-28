//
//  ToastModifier.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 28/8/26.
//

import SwiftUI
import FHKCore

struct ToastModifier: ViewModifier, ToastAppareanceProtocol {
    @Binding var isVisible: Bool
    let info: FHKToastInfo
    
    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            
            if isVisible {
                content
                    .font(fontText)
                    .foregroundColor(getTextColor())
                    .padding(.horizontal, FHKSize.size16)
                    .background(getBackgroundColor())
                    .cornerRadius(cornerRadius)
                    .shadow(radius: shadow)
                    .padding(.top, safeAreaPadding())
                    .transition(.move(edge: .top))
                    .offset(y: isVisible ? paddingOffset() : -UIScreen.main.bounds.height)
                    .animation(.easeInOut(duration: 2), value: isVisible)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                isVisible = false
                            }
                        }
                    }
                    .padding()
                Spacer()
            }
        }
    }
    
    private func getBackgroundColor() -> Color {
        switch info.type {
        case .success:
            return FHKColor.success
        case .error:
            return FHKColor.error
        case .warning:
            return FHKColor.warning
        case .notification:
            return FHKColor.basicBlack
        }
    }
    
    private func getTextColor() -> Color {
        switch info.type {
        case .success, .error, .notification:
            return FHKColor.basicWhite
        case .warning:
            return FHKColor.basicBlack
        }
    }
    
    private func paddingOffset() -> CGFloat {
        let valuePadding: CGFloat = -100
        print(valuePadding)
        return valuePadding
    }
    
    private func safeAreaPadding() -> CGFloat {
        let keyWindow = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
        
        let topPadding = keyWindow?.safeAreaInsets.top ?? 0
        let finalTopPadding = topPadding >= 20 ? topPadding : 0
        return finalTopPadding
    }
}
