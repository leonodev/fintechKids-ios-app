//
//  FHKPermissionView.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 12/9/26.
//

import SwiftUI
import FHKCore

public struct FHKPermissionView: View {
    @Environment(\.dismiss) var dismiss
    let provider: FHKPermission
    
    // Feedback háptico para mejorar la UX
    private let haptic = UIImpactFeedbackGenerator(style: .medium)
    
    public init(provider: FHKPermission) {
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
            
            Text(provider.title().localized.capitalizingFirstLetter())
                .font(.title.bold())
            Spacer()
            
            LottieView(animationName: Lotties.camera,
                        loopMode: .loop,
                        contentMode: .scaleAspectFit)
            
            Spacer()
            Text(provider.message().localized.capitalizingFirstLetter())
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding(.top, 40)
    }
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            
            FHKButtonPrimary(title: provider.titleButtonSetting().localized.uppercased(),
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
            FHKButtonPrimary(title: provider.titleButtonLater().localized.uppercased(),
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
        
        if provider.status() == .denied {
            // Deep Linking a los ajustes de la App
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        } else {
            Task {
                let _ = await provider.requestPermission()
                dismiss()
            }
        }
    }
}
