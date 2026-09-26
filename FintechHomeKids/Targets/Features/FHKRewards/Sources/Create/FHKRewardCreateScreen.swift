//
//  FHKRewardCreateScreen.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 26/9/26.
//

import SwiftUI
import FHKCore
import FHKDesignSystem
import FHKDomain

public struct FHKRewardCreateScreen: View {
    @State private var viewModel: FHKRewardCreateScreenVM
    @Router private var router: NavigationRouter<RoutesDestination>
    
    public init() {
        self._viewModel = State(initialValue: FHKRewardCreateScreenVM())
    }
    
    public var body: some View {
        FHKScreenContainer(title: viewModel.viewState.rewardsCreateTitle) {
            switch viewModel.viewState.createState {
               
            case .loading:
                loadingView
                
            case .finish, .loaded:
                loadedView
            }
        }
        .observeLanguage()
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
                options: viewModel.viewState.workDurationType,
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


extension FHKRewardCreateScreen {
    private func getInfoReward() -> FHKRewardEntity? {
        guard let emailParent = viewModel.getParentMail() else {
            viewModel.displayNotification(message: viewModel.viewState.msnWarningMissingEmail, type: .error)
            return nil
        }
        
        return FHKRewardEntity(createdAt: Date().toUTC,
                               name: viewModel.viewState.name,
                               timeRequiered: viewModel.viewState.timeRequired,
                               coinsRequiered: viewModel.viewState.coinsRequired.toIntOrZero,
                               emailParent: emailParent)
    }
}

// Para ver unicamente la pantalla
#Preview("Design / Isolated UI") {
    FHKPreview {
        FHKRewardCreateScreen()
            .withPreviewRouter()
    }
}

