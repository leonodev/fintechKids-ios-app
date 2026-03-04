//
//  RegisterScreen.swift
//  fintechKids
//
//  Created by Fredy Leon on 23/1/26.
//

import SwiftUI
import FHKDesignSystem
import FHKCore

struct RegisterScreen<VM: RegisterScreenVM>: View {
    @State var viewModel: VM
    @NavigationRouterWrapper<Routes> private var router
    
    var body: some View {
        ScreenContainer(title: Routes.register.title) {
            switch viewModel.viewState.registerState {
                
            case .loading:
                LoadingView(msn: viewModel.viewState.msnLoading)
                
            default:
                formView
            }
        }
        .onChange(of: viewModel.viewState.registerState) { _, state in
            switch state {
            case .finish(nil), .error:
                viewModel.modalManager.show {
                    modalConfirmation
                }
                
            default:
                break
            }
        }
    }
    
    var formView: some View {
        VStack(alignment: .leading) {
            Spacer()
            
            LottieView(animationName: Lotties.register,
                       loopMode: .loop,
                       contentMode: .scaleAspectFit)
            .frame(height: 200)
            
            // text informative
            informativeText

            // cardview with credentials
            credentialsField
            
            Spacer()
            // button register
            registermeButton
            
            Spacer()
        }
        .padding()
    }
    
    var informativeText: some View {
        Text(viewModel.viewState.registerEmailInstruction)
            .lineSpacing(4)
            .font(.PangramSans.bold(FHKSize.size16))
            .foregroundColor(FHKColor.lunarSand.opacity(0.5))
            .padding()
    }
    
    var credentialsField: some View {
        BasicCardView(action: {_ in },
                      content: {
            
            VStack(alignment: .leading) {
                GradientBorderField(text: $viewModel.viewState.emailFamily,
                                    placeholder: viewModel.viewState.emailFamilyPlaceholder)
                .padding(.top, FHKSize.size04)
                
                GradientBorderField(text: $viewModel.viewState.password,
                                    placeholder: viewModel.viewState.passwordPlaceholder,
                                    isSecure: true)
                
                .padding(.top, FHKSize.size12)
            }
        })
        .padding(.top, FHKSize.size24)
    }
    
    var registermeButton: some View {
        FHKButtonPrimary(title: viewModel.viewState.titleRegisterBtn,
                         state: viewModel.viewState.isBtnContinueEnable,
                         mode: .solid,
                         action: {
            Task {
                await viewModel.action(.registerUser)
            }
        })
    }
    
    var modalConfirmation: some View {
        VStack(alignment: .leading, spacing: FHKSpace.space08) {
            FHKInformationView(title: viewModel.viewState.titleRegisterConfirmation,
                               message: viewModel.viewState.msnRegisterConfirmation,
                               type: viewModel.viewState.stateRegisterOperation,
                               confirmButtonText: viewModel.viewState.titleButtonContinue,
                                confirmAction: {
                viewModel.modalManager.dismiss()
                router.pop()
            })
        }
    }
}

#Preview {
    RegisterScreen(viewModel: RegisterScreenVM())
}
