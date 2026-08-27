//
//  FHKConfirmationView.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 29/1/26.
//

import SwiftUI

public struct FHKConfirmationView: View {
    let message: String
    let confirmButtonText: String
    let cancelButtonText: String
    let confirmAction: () -> Void
    let cancelAction: () -> Void
    
    public init(message: String, confirmButtonText: String,
                cancelButtonText: String,
                confirmAction: @escaping () -> Void,
                cancelAction: @escaping () -> Void
    ) {
        self.message = message
        self.confirmButtonText = confirmButtonText
        self.cancelButtonText = cancelButtonText
        self.confirmAction = confirmAction
        self.cancelAction = cancelAction
    }

    public var body: some View {
        VStack(spacing: FHKSpace.space24) {
            
            VStack(spacing: 8) {
               
                Text(message)
                    .font(.PangramSans.medium(18))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, FHKSpace.space12)

            // actions button
            HStack(spacing: FHKSpace.space12) {
                // Botón secundario (Cancel)
                Button(action: cancelAction) {
                    Text(cancelButtonText)
                        .font(.PangramSans.bold(16))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, FHKSpace.space16)
                        .background(Color.white.opacity(0.1))
                        .foregroundColor(.white)
                        .cornerRadius(FHKSize.size12)
                }

                // Primary button (Confirm)
                Button(action: confirmAction) {
                    Text(confirmButtonText)
                        .font(.PangramSans.bold(16))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, FHKSize.size16)
                        .background(FHKColor.fuchsiaPink)
                        .foregroundColor(FHKColor.basicWhite)
                        .cornerRadius(FHKSize.size12)
                        .shadow(color: .purple.opacity(0.3), radius: 10, x: 0, y: 5)
                }
            }
        }
        .padding(FHKSpace.space24)
    }
}

#Preview {
    VStack {
        Spacer()
        FHKConfirmationView(message: "Desea eliminar este miembro de su falimia?",
                            confirmButtonText: "Eliminar",
                            cancelButtonText: "Cancelar",
                            confirmAction: {
            
        },
                            cancelAction: {
            
        })
        Spacer()
    }
    .background(FHKColor.indigo)
}
