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
import FHKUtils

struct RegisterScreen<VM: RegisterScreenVM>: View {
    @State var viewModel: VM
    @NavigationRouterWrapper<Routes> private var router
    @Inject(\.modalManager) var modalManager: FHKModalProtocol
    
    var body: some View {
        ScreenContainer {
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
            
            // cardview with credentials
            credentialsField
            
            Spacer()
            // button register
            registermeButton
        }
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
                               type: .success,
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
