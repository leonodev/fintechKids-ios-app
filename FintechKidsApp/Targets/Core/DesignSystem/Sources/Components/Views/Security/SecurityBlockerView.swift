//
//  SecurityBlockerView.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 6/1/26.
//

import SwiftUI

public struct SecurityBlockerView: View {
    let title: String
    let msn: String
    let titleBtn: String
    
    public init(title: String, msn: String, titleBtn: String) {
        self.title = title
        self.msn = msn
        self.titleBtn = titleBtn
    }
    
    public var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "lock.shield.fill")
                .font(.PangramSans.bold(FHKSize.size80))
                .foregroundStyle(.red.gradient)
            
            Text(title)
                .font(.PangramSans.bold(FHKSize.size24))
            
            Text(msn)
                .multilineTextAlignment(.center)
                .padding(.horizontal, FHKSize.size40)
                .font(.PangramSans.Compact.regular(FHKSize.size16))
            
            Button(action: { exit(0) }) {
                Text(titleBtn)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.primary)
                    .cornerRadius(FHKSize.size12)
                    .foregroundColor(FHKColor.backgroundPrimary)
            }
            .padding(.horizontal, FHKSize.size40)
        }
    }
}

#Preview {
    SecurityBlockerView(
        title: "Dispositivo no compatible",
        msn: "Por razones de seguridad, esta aplicación no puede ejecutarse en dispositivos con modificaciones de sistema (Jailbreak).",
        titleBtn: "Cerrar Aplicación"
    )
}
