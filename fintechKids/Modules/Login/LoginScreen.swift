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
import FHKCore

struct LoginScreen<VM: LoginScreenVM>: View {
    @State var viewModel: VM
    
    var body: some View {
        ScreenContainer {
            switch viewModel.model.loginState {
            case .none:
                FormView
                
            case .loading:
                LoadingView(msn: viewModel.model.msnLoading)
                
            case .loaded(let t):
                Text("loaded")
                
            case .error(let error):
                ErrorView(title: viewModel.model.titleError,
                          msnError: viewModel.model.msnError,
                          titleBtn: viewModel.model.titleBtnError,
                          onActionPressed: {
                    
                })
                Text("error")
            }
        }
    }
    
    var FormView: some View {
        ZStack {
            
            VStack(spacing: 20) {
                
                LottieView(animationName: Lotties.login,
                           loopMode: .loop,
                           contentMode: .scaleAspectFit)
                .frame(height: 300)
                
                // Titles
                VStack(spacing: 4) {
                    
                    Text(viewModel.model.wellcome)
                        .font(.PangramSans.bold(FHKSize.size28))
                        .foregroundColor(FHKColor.fuchsiaPink)
                    
                    Text(viewModel.model.startSesionYourAccount)
                        .font(.PangramSans.bold(FHKSize.size16))
                        .foregroundColor(.purple.opacity(0.3))
                }
                .padding(.bottom, 20)
                
                // Fields
                VStack(spacing: 15) {
                    GradientBorderField(text: $viewModel.model.email,
                                        placeholder: viewModel.model.emailPlaceholder)
                    
                    GradientBorderField(text: $viewModel.model.password,
                                        placeholder: viewModel.model.passwordPlaceholder,
                                        isSecure: true)
                }
                
                HStack {
                    Spacer()
                    Button(action: {
                        // Acción para recuperar contraseña
                    }, label: {
                        Text(viewModel.model.youForgotYourPassword)
                            .font(.PangramSans.bold(FHKSize.size16))
                            .foregroundColor(FHKColor.fuchsiaPink)
                    })
                }
                .padding(.trailing, 4)
                
                FHKButtonPrimary(title: viewModel.model.startSesion,
                                 state: .enabled,
                                 mode: .solid,
                                 action: {
                    Task {
                        await viewModel.action(.doLogin)
                    }
                })
                
                Button(action: {
                    // Acción para ir a registro
                }, label: {
                    HStack {
                        Text(viewModel.model.youNotHaveAccount)
                            .font(.PangramSans.extraboldItalic(FHKSize.size16))
                            .foregroundColor(FHKColor.basicBlack.opacity(0.3))
                        
                        Text(viewModel.model.register)
                            .underline()
                            .font(.PangramSans.bold(FHKSize.size16))
                            .foregroundColor(FHKColor.basicBlack.opacity(0.7))
                            
                    }
                    .padding(.top, 14)
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

#Preview {
    LoginScreen(viewModel: LoginScreenVM())
}
