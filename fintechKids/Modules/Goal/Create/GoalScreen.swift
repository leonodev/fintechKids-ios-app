//
//  GoalScreen.swift
//  fintechKids
//
//  Created by Fredy Leon on 1/1/26.
//

import SwiftUI
import FHKCore
import FHKUtils
import FHKDesignSystem
import FHKDomain

struct GoalScreen<VM: GoalScreenVM>: View {
    @State var viewModel: VM
    @NavigationRouterWrapper<Routes> private var router
    
    var body: some View {
        ScreenContainer(title: Routes.createGoal.title) {
            switch viewModel.viewState.goalState {
                
            case .loading:
                loadingView
                
            case .finish, .loaded:
                loadedView
            }
        }
        .onChange(of: viewModel.viewState.goalState) { _, state in
            switch state {
            case .finish(.success):
                viewModel.fhkModal.show {
                    resultModalSuccess
                }
            case .finish(result: .error):
                viewModel.fhkModal.show {
                    resultModalError
                }
            default:
                break
            }
        }
    }
    
    var loadingView: some View {
        LoadingView(msn: viewModel.viewState.msnLoading)
    }
    
    var loadedView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: FHKSpace.space08) {
                
                FHKTextField(text: $viewModel.viewState.goalName,
                             placeholder: viewModel.viewState.goalNamePlaceholder)
                .padding(.top, FHKSize.size24)
                
                FHKRadioGroupField(
                    title: viewModel.viewState.titleHowGetGoal,
                    options: viewModel.viewState.rewardsOptions,
                    selection: $viewModel.viewState.selectedGoalType,
                    onSelectionChanged: { value in
                        print("Se seleccionó: \(value)")
                    }
                )
                .padding(.top, FHKSize.size24)
                 
                if viewModel.viewState.selectedGoalType != nil &&
                    viewModel.viewState.selectedGoalType == .time {
                   
                    FHKRadioGroupField(
                        title: "",
                        options: viewModel.viewState.durationOptions,
                        selection: $viewModel.viewState.selectedDurationType,
                        onSelectionChanged: { value in
                            print("Se seleccionó: \(value)")
                        }
                    )
                    
                    FHKTextField(text: $viewModel.viewState.rewardsValue,
                                 placeholder: viewModel.viewState.rewardsValuePlaceholder)
                    .onlyIntegers(text: $viewModel.viewState.rewardsValue)
                    .padding(.top)
                }
                
                if viewModel.viewState.selectedGoalType != nil &&
                    viewModel.viewState.selectedGoalType == .coins {
                    
                    FHKTextField(text: $viewModel.viewState.rewardsValue,
                                 placeholder: viewModel.viewState.rewardsValuePlaceholder)
                    .onlyIntegers(text: $viewModel.viewState.rewardsValue)
                    .padding(.top, FHKSize.size24)
                    HStack {
                        Spacer()
                        Text(viewModel.viewState.valueReal(value: viewModel.viewState.rewardsValue))
                            .font(.PangramSans.bold(FHKSize.size16))
                            .foregroundColor(FHKColor.lunarSand.opacity(0.3))
                    }  
                }
 
                Spacer()
                
                FHKButtonPrimary(title: viewModel.viewState.titleBtnCreateGoal,
                                 state: .enabled,
                                 mode: .solid,
                                 action: {
                    Task {
                        guard let rewardsType = viewModel.getWorkType() else { return }
                        switch rewardsType {
                        case .time:
                            await viewModel.action(.createGoalWithTime)
                        case .coins:
                            await viewModel.action(.createGoalWithCoin)
                        }
                    }
                })
                .padding(.top, FHKSpace.space32)
            }
            .padding()
        }
    }
    
    var resultModalSuccess: some View {
        VStack(alignment: .leading, spacing: FHKSpace.space08) {
            FHKInformationView(message: viewModel.viewState.msnCreateGoalSuccess,
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
            FHKInformationView(message: viewModel.viewState.msnCreateGoalFail,
                               type: .error,
                               confirmButtonText: viewModel.viewState.titleBtnOperationError,
                                confirmAction: {
                viewModel.fhkModal.dismiss()
            })
        }
    }
}

#Preview {
    GoalScreen(viewModel: GoalScreenVM())
}
