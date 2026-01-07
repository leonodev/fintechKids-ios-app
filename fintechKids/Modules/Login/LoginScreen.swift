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
    
    var body: some View {
        ScreenContainer {
            ZStack {
                
                VStack(spacing: 20) {
                    
                    LottieView(animationName: Lotties.login,
                               loopMode: .loop,
                               contentMode: .scaleAspectFit)
                    .frame(height: 150)
                    
                    // Titles
                    VStack(spacing: 4) {
                        Text("wellcome".localized().capitalizingFirstLetter())
                            .font(.PangramSans.bold(FHKSize.size28))
                        Text("login_with_your_account".localized())
                            .font(.PangramSans.bold(FHKSize.size16))
                            .foregroundColor(.purple.opacity(0.3))
                    }
                    .padding(.bottom, 20)
                    
                    // Fields
                    VStack(spacing: 15) {
                        GradientBorderField(text: $email, placeholder: "email".localized())
                        
                        GradientBorderField(text: $password, placeholder: "password".localized(), isSecure: true)
                    }
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            // Acción para recuperar contraseña
                        }, label: {
                            Text("you_forgot_your_password".localized())
                                .font(.PangramSans.bold(FHKSize.size16))
                                .foregroundColor(.fuchsiaPink)
                        })
                    }
                    .padding(.trailing, 4)
                    
                    FHKButtonPrimary(title: "start_sesion".localized().capitalizingFirstLetter(),
                                     state: .enabled,
                                     mode: .solid,
                                     action: {
                        // router.navigate(to: .login)
                    })
                    
                    Button(action: {
                        // Acción para ir a registro
                    }, label: {
                        HStack {
                            Text("you_not_have_an_account".localized())
                                .font(.PangramSans.extraboldItalic(FHKSize.size16))
                                .foregroundColor(.basicWhite.opacity(0.6))
                            
                            Text("register".localized())
                                .font(.PangramSans.bold(FHKSize.size16))
                                .foregroundColor(.basicWhite.opacity(0.8))
                        }
                    })
                    .font(.caption)
                }
                .padding(30)
                .background(
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
