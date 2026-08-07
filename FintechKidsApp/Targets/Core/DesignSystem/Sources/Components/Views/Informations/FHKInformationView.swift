//
//  FHKInformationView.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 2/2/26.
//

import SwiftUI

public struct FHKInformationView: View {
    
    public enum ResultType {
        case success
        case error
        
        var colorBackground: Color {
            switch self {
            case .success:
                return FHKColor.success
                
            case .error:
                return FHKColor.error
            }
        }
        
        var image: Image {
            switch self {
            case .success:
                return Image(systemName: "checkmark.circle")
                
            case .error:
                return Image(systemName: "xmark.circle")
            }
        }
    }
    
    
    let message: String
    let type: ResultType
    let confirmButtonText: String
    let confirmAction: () -> Void
    
    public init(message: String,
                type: ResultType,
                confirmButtonText: String,
                confirmAction: @escaping () -> Void
    ) {
        self.message = message
        self.type = type
        self.confirmButtonText = confirmButtonText
        self.confirmAction = confirmAction
    }

    public var body: some View {
        VStack(spacing: FHKSpace.space24) {
            
            VStack(spacing: 8) {
                type.image
                    .resizable()
                    .frame(width: FHKSize.size72, height: FHKSize.size72)
                    .foregroundStyle(type.colorBackground)
                    .padding(.bottom, FHKSpace.space32)
                
                Text(message)
                    .font(.PangramSans.medium(18))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, FHKSpace.space12)
            .padding(.bottom, FHKSpace.space32)

            // actions button
            HStack(spacing: FHKSpace.space12) {
            
                // Primary button (Confirm)
                Button(action: confirmAction) {
                    Text(confirmButtonText)
                        .font(.PangramSans.bold(16))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, FHKSize.size16)
                        .background(type.colorBackground)
                        .foregroundColor(FHKColor.basicWhite)
                        .cornerRadius(FHKSize.size12)
                        .shadow(color: .purple.opacity(0.3), radius: 10, x: 0, y: 5)
                }
            }
        }
        .padding(FHKSpace.space24)
        .accessibilityIdentifier(type == .success ? "view_result_success_id" : "view_result_fail_id")
    }
}

#Preview {
    VStack {
        Spacer()
        FHKInformationView(message: "Desea eliminar este miembro de su falimia?",
                            type: .success,
                            confirmButtonText: "Eliminar",
                            confirmAction: {
            
        })
        Spacer()
    }
    .background(FHKColor.indigo)
}
