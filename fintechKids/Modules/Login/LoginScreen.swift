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
import FHKInjections

struct LoginScreen<VM: LoginScreenVM>: View {
    @NavigationRouterWrapper<Routes> private var router
    @State var viewModel: VM
    
    @Inject(\.toastService) var toastService: ToastServiceProtocol
    
    var body: some View {
        ScreenContainer {
            switch viewModel.model.loginState {
            case .loaded:
                FormView
                
            case .loading:
                LoadingView(msn: viewModel.model.msnLoading)
                
            case .error:
                ErrorView(title: viewModel.model.titleError,
                          msnError: viewModel.model.msnError,
                          titleBtn: viewModel.model.titleBtnError,
                          onActionPressed: {
                })
                Text("error")
            }
        }
        .onChange(of: viewModel.model.isLogginSuccess) { _, isSucces in
            if isSucces {
                router.navigate(to: .home)
            }
        }
    }
    
    var FormView: some View {
        ZStack {
            
            VStack(spacing: 20) {
                
                LottieView(animationName: Lotties.login,
                           loopMode: .loop,
                           contentMode: .scaleAspectFit)
                .frame(height: 200)
                
                // Titles
                VStack(spacing: 4) {
                    
                    Text(viewModel.model.wellcome)
                        .font(.PangramSans.bold(FHKSize.size28))
                        .foregroundColor(FHKColor.lunarSand)
                    
                    Text(viewModel.model.startSesionYourAccount)
                        .font(.PangramSans.bold(FHKSize.size16))
                        .foregroundColor(FHKColor.lunarSand.opacity(0.6))
                }
                .padding(.bottom, FHKSpace.space20)
                
                // Fields
                VStack(spacing: FHKSpace.space16) {
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
                            .foregroundColor(FHKColor.lunarSand)
                    })
                }
                .padding(.trailing, FHKSpace.space04)
                
                FHKButtonPrimary(title: viewModel.model.startSesion,
                                 state: .enabled,
                                 mode: .solid,
                                 action: {
                    Task {
                        await viewModel.action(.doLogin)
                    }
                })
                
                Button(action: {
                    router.navigate(to: .register)
                }, label: {
                    HStack {
                        Text(viewModel.model.youNotHaveAccount)
                            .font(.PangramSans.extraboldItalic(FHKSize.size16))
                            .foregroundColor(FHKColor.silver.opacity(0.8))
                        
                        Text(viewModel.model.register)
                            .underline()
                            .font(.PangramSans.bold(FHKSize.size16))
                            .foregroundColor(FHKColor.pastelPink)
                            .padding(.bottom, 2)
                    }
                    .padding(.top, FHKSpace.space16)
                })
                .font(.caption)
                
                Button(action: {
                    toastService.show(info:
                                        ToastInfo(
                                            type: .notification,
                                            message: "Prueba de notificacion si incluso a doble linea o mas ...",
                                            hasIcon: true),
                                      duration: 5.0)
                },
                label: {
                    Text("Mostrar Notificacion")
                })
            }
            .padding(FHKSpace.space28)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.white.opacity(0.15))
                    .shadow(radius: 20)
            )
            .padding(.horizontal, FHKSpace.space28)
            .shadow(radius: 20)
        }
        .padding(.bottom, FHKSpace.space28)
    }
}

#Preview {
    LoginScreen(viewModel: LoginScreenVM())
}
