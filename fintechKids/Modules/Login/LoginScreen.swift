//
//  LoginScreen.swift
//  fintechKids
//
//  Created by Fredy Leon on 11/12/25.
//

import SwiftUI
import Lottie
import FHKDesignSystem
import FHKUtils

struct LoginScreen: View {
    @State private var email = ""
    @State private var password = ""
    
    // Degradado para el borde y el botón
    let accentGradient = LinearGradient(
        gradient: Gradient(colors: [Color.blue, Color.purple]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    var body: some View {
        ScreenContainer {
            ZStack {
                
                VStack(spacing: 20) {
                    
                    LottieView(animationName: Lotties.login,
                               loopMode: .loop,
                               contentMode: .scaleAspectFit)
                    .frame(height: 150)
                    
                    // Títulos
                    VStack(spacing: 4) {
                        Text("wellcome".localized().capitalizingFirstLetter())
                            .font(.PangramSans.bold(FHKSize.size28))
                        Text("login_with_your_account".localized())
                            .font(.PangramSans.bold(FHKSize.size16))
                            .foregroundColor(.purple.opacity(0.3))
                    }
                    .padding(.bottom, 20)
                    
                    // Campos de Entrada
                    VStack(spacing: 15) {
                        GradientBorderField(text: $email, placeholder: "email".localized())
                        
                        GradientBorderField(text: $password, placeholder: "password".localized(), isSecure: true)
                    }
                    
                    // Enlace "¿Olvidaste la Contraseña?"
                    HStack {
                        Spacer()
                        Button(action: {
                            // Acción para recuperar contraseña
                        }) {
                            Text("you_forgot_your_password".localized())
                                .font(.PangramSans.bold(FHKSize.size16))
                                .foregroundColor(.fuchsiaPink)
                        }
                    }
                    .padding(.trailing, 4)
                    
                    // Botón de Inicio de Sesión
                    FHKButtonPrimary(title: "start_sesion".localized().capitalizingFirstLetter(),
                                     state: .enabled,
                                     mode: .solid,
                                     action: {
                        // router.navigate(to: .login)
                    })
                    
                    // Enlace de Registro
                    Button(action: {
                        // Acción para ir a registro
                    }) {
                        HStack {
                            Text("you_not_have_an_account".localized())
                                .font(.PangramSans.extraboldItalic(FHKSize.size16))
                                .foregroundColor(.basicWhite.opacity(0.6))
                            
                            Text("register".localized())
                                .font(.PangramSans.bold(FHKSize.size16))
                                .foregroundColor(.basicWhite.opacity(0.8))
                        }
                    }
                    .font(.caption)
                }
                .padding(30)
                .background(
                    // Fondo semi-transparente para la tarjeta
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.white.opacity(0.15))
                        .shadow(radius: 20)
                )
                .padding(.horizontal, 30)
            }
        }
    }
}

#Preview {
    LoginScreen()
}


// --- 1. COMPONENTE AUXILIAR: Campo de Texto con Borde Degradado ---
struct GradientBorderField: View {
    @Binding var text: String
    var placeholder: String
    var isSecure: Bool = false
    
    // Degradado para el borde y el botón
    let accentGradient = LinearGradient(
        gradient: Gradient(colors: [Color.blue, Color.purple]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    var body: some View {
        // Contenedor para aplicar el degradado al borde
        ZStack {
            // El degradado que actuará como el borde
            RoundedRectangle(cornerRadius: 12)
                .stroke(accentGradient, lineWidth: 3)
            
            // El campo de texto en sí
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white) // Fondo blanco para el campo
            .cornerRadius(10)
            .padding(4) // Ajuste para que se vea el degradado del ZStack
        }
        .frame(height: 50)
    }
}
