//
//  PermissionRequestView.swift
//  fintechKids
//
//  Created by Fredy Leon on 3/3/26.
//

import SwiftUI
import FHKCore
import FHKDesignSystem

public struct PermissionRequestView: View {
    @Environment(\.dismiss) var dismiss
    let provider: any FHKPermissionProtocol
    
    // Feedback háptico para mejorar la UX
    private let haptic = UIImpactFeedbackGenerator(style: .medium)
    
    public init(provider: any FHKPermissionProtocol) {
        self.provider = provider
    }
    
    public var body: some View {
        VStack(spacing: 30) {
            headerSection
            
            Spacer()
            
            actionButtons
        }
        .padding(32)
    }
    
    private var headerSection: some View {
        VStack(spacing: 20) {
            
            Text(provider.title)
                .font(.title.bold())
            Spacer()
            
            LottieView(animationName: Lotties.camera,
                        loopMode: .loop,
                        contentMode: .scaleAspectFit)
            
            Spacer()
            Text(provider.message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding(.top, 40)
    }
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            
            FHKButtonPrimary(title: provider.titleButtonSetting,
                             state: .enabled,
                             mode: .solid,
                             action: handleAction)
            
//            Button(action: handleAction) {
//                Text(provider.status == .denied ? "Ir a Ajustes" : "Continuar")
//                    .font(.headline)
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(FHKButtonAppearance.solidBackgroundColor())
//                    .foregroundColor(.white)
//                    .cornerRadius(16)
//            }
            FHKButtonPrimary(title: provider.titleButtonLater,
                             textColor: FHKColor.gray,
                             style: .outlined,
                             state: .enabled,
                             mode: .glass(.clear),
                             action: {
                dismiss()
            })
        }
    }
    
    private func handleAction() {
        haptic.prepare()
        haptic.impactOccurred()
        
        if provider.status == .denied {
            // Deep Linking a los ajustes de la App
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        } else {
            provider.requestPermission { _ in
                DispatchQueue.main.async { dismiss() }
            }
        }
    }
}
