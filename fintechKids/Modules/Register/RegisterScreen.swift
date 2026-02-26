//
//  RegisterScreen.swift
//  fintechKids
//
//  Created by Fredy Leon on 23/1/26.
//

import SwiftUI
import FHKDesignSystem
import FHKInjections
import FHKCore
import FHKDomain

struct RegisterScreen<VM: RegisterScreenVM>: View {
    @State var viewModel: VM
    @NavigationRouterWrapper<Routes> private var router
    
    // Properties Injected
    private var modalManager: any FHKModalProtocol {
        inject.modalManager
    }
    
    var body: some View {
        ScreenContainer(title: Routes.register.title) {
            switch viewModel.model.registerState {
                
            case .loading:
                LoadingView(msn: viewModel.model.msnLoading)
                
            default:
                formView
            }
        }
        .onChange(of: viewModel.model.registerState) { _, state in
            switch state {
            case .finish(nil), .error:
                modalManager.show {
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
        Text(viewModel.model.registerEmailInstruction)
            .lineSpacing(4)
            .font(.PangramSans.bold(FHKSize.size16))
            .foregroundColor(FHKColor.lunarSand.opacity(0.5))
            .padding()
    }
    
    var credentialsField: some View {
        BasicCardView(action: {_ in },
                      content: {
            
            VStack(alignment: .leading) {
                GradientBorderField(text: $viewModel.model.emailFamily,
                                    placeholder: viewModel.model.emailFamilyPlaceholder)
                .padding(.top, FHKSize.size04)
                
                GradientBorderField(text: $viewModel.model.password,
                                    placeholder: viewModel.model.passwordPlaceholder,
                                    isSecure: true)
                
                .padding(.top, FHKSize.size12)
            }
        })
        .padding(.top, FHKSize.size24)
    }
    
    var registermeButton: some View {
        FHKButtonPrimary(title: viewModel.model.titleRegisterBtn,
                         state: viewModel.model.isBtnContinueEnable,
                         mode: .solid,
                         action: {
            Task {
                await viewModel.action(.registerUser)
            }
        })
    }
    
    var modalConfirmation: some View {
        VStack(alignment: .leading, spacing: FHKSpace.space08) {
            FHKInformationView(title: viewModel.model.titleRegisterConfirmation,
                               message: viewModel.model.msnRegisterConfirmation,
                               type: viewModel.model.stateRegisterOperation,
                               confirmButtonText: viewModel.model.titleButtonContinue,
                                confirmAction: {
                modalManager.dismiss()
                router.pop()
            })
        }
    }
}

#Preview {
    RegisterScreen(viewModel: RegisterScreenVM())
}
