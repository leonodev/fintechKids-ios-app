//
//  RewardCreateScreen.swift
//  fintechKids
//
//  Created by fleon  on 19/5/26.
//

import SwiftUI
import FHKCore
import FHKDesignSystem
import FHKDomain
import FHKUtils

struct RewardCreateScreen<VM: RewardCreateScreenVM>: View {
    @State var viewModel: VM
    @NavigationRouterWrapper<Routes> private var router
    
    var body: some View {
        ScreenContainer(title: Routes.Titles.createReward) {
            
            switch viewModel.viewState.createState {
               
            case .loading:
                loadingView
                
            case .finish, .loaded:
                loadedView
            }
        }
        .onChange(of: viewModel.viewState.createState) { _, state in
            switch state {
            case .finish(result: .success):
                viewModel.fhkModal.show(
                    onDismiss: {
                        print("El usuario cerró el modal")
                    }, content: {
                        resultModalSuccess
                    }
                )
            case .finish(result: .error):
                viewModel.fhkModal.show(
                    onDismiss: {
                        print("El usuario cerró el modal")
                    }, content: {
                        resultModalError
                    }
                )
                
            default:
                break
            }
        }
    }
    
    var loadingView: some View {
        LoadingView(msn: viewModel.viewState.msnLoading)
    }
    
    var loadedView: some View {
        VStack {
            Text(viewModel.viewState.msnCreateRewardInstruction)
                .font(.PangramSans.bold(FHKSize.size16))
                .foregroundColor(FHKColor.lunarSand.opacity(0.5))
                .padding(.bottom, FHKSpace.space32)
            
            FHKTextField(text: $viewModel.viewState.name,
                         placeholder: viewModel.viewState.namePlaceholder)
            .padding(.bottom, FHKSpace.space24)
            
            FHKTextField(text: $viewModel.viewState.timeRequired,
                         placeholder: viewModel.viewState.timeRequiredPlaceholder,
                         keyboardType: .numberPad)
            
            FHKRadioGroupField(
                title: "",
                options: OptionsCommon.getOptionDurationType(),
                selection: $viewModel.viewState.selectedDurationType,
                onSelectionChanged: { value in
                    print("Se seleccionó: \(value)")
                }
            )
            .padding(.top, -FHKSpace.space24)
            .padding(.bottom, FHKSpace.space24)
            
            FHKTextField(text: $viewModel.viewState.coinsRequired,
                         placeholder: viewModel.viewState.coinsRequiredPlaceholder,
                         keyboardType: .numberPad)
            
            Spacer()
            
            FHKButtonPrimary(title: viewModel.viewState.buttonCreateRewardTitle,
                             state: viewModel.viewState.isBtnCreateRewardEnable,
                             mode: .solid,
                             action: {
                Task {
                    guard let infoReward = getInfoReward() else {
                        viewModel.displayNotification(message: viewModel.viewState.msnErrorCannotCreateReward,
                                                      type: .error)
                        return
                    }
                    await viewModel.action(.createReward(reward: infoReward))
                }
            })
        }
        .padding()
    }
    
    var resultModalSuccess: some View {
        VStack(alignment: .leading, spacing: FHKSpace.space08) {
            FHKInformationView(message: viewModel.viewState.msnCreateRewardSuccess,
                               type: .success,
                               confirmButtonText: viewModel.viewState.titleButtonContinue,
                                confirmAction: {
                viewModel.fhkModal.dismiss()
                router.pop()
            })
        }
    }
    
    var resultModalError: some View {
        VStack(alignment: .leading, spacing: FHKSpace.space08) {
            FHKInformationView(message: viewModel.viewState.msnCreateRewardFail,
                               type: .error,
                               confirmButtonText: viewModel.viewState.titleButtonContinue,
                                confirmAction: {
                viewModel.fhkModal.dismiss()
            })
        }
    }
    
    
}

extension RewardCreateScreen {
    private func getInfoReward() -> RewardEntity? {
        guard let emailParent = viewModel.getParentMail() else {
            viewModel.displayNotification(message: viewModel.viewState.msnWarningMissingEmail, type: .error)
            return nil
        }
        
        return RewardEntity(createdAt: Date().toUTC,
                            name: viewModel.viewState.name,
                            timeRequiered: viewModel.viewState.timeRequired,
                            coinsRequiered: viewModel.viewState.coinsRequired.toIntOrZero,
                            emailParent: emailParent)
    }
}
