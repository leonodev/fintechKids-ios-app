//
//  TaskCreateScreen.swift
//  fintechKids
//
//  Created by Fredy Leon on 14/3/26.
//

import SwiftUI
import FHKCore
import FHKDesignSystem
import FHKUtils
import FHKDomain

struct TaskCreateScreen<VM: TaskCreateScreenVM>: View {
    @State var viewModel: VM
    //@State var selectedDuration: String?
    @NavigationRouterWrapper<Routes> private var router
    
    var body: some View {
        ScreenContainer(title: viewModel.viewState.titleCreateNewTask) {
            switch viewModel.viewState.taskCreateState {
                
            case .loading:
                loadingView
                
            case .finish, .loaded:
                loadedView
            }
        }
        .onChange(of: viewModel.viewState.taskCreateState) { _, state in
            switch state {
            case .finish(let result):
                
                switch result {
                case .success:
                    viewModel.fhkModal.show {
                        resultModalSuccess
                    }
   
                case .error:
                    viewModel.fhkModal.show {
                        modalInformationError
                    }
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
                
                FHKTextField(text: $viewModel.viewState.taskName,
                             placeholder: viewModel.viewState.taskNamePlaceholder)
                .padding(.top, FHKSize.size04)
                
                Text(viewModel.viewState.titleDescriptionTask)
                    .font(.PangramSans.bold(FHKSize.size16))
                    .foregroundColor(FHKColor.lunarSand.opacity(0.9))
                    .padding(.top, FHKSize.size16)
                    .padding(.horizontal, FHKSpace.space08)
                
                FHKEditorField(text: $viewModel.viewState.taskDescription)
                    .padding(.horizontal, FHKSpace.space08)
                
                FHKRadioGroupField(
                    title: viewModel.viewState.titleDurationType,
                    options: viewModel.viewState.durationOptions,
                    selection: $viewModel.viewState.selectedDuration,
                    onSelectionChanged: { value in
                        print("Se seleccionó: \(value)")
                    }
                )
                .padding(.horizontal, FHKSpace.space08)
                
                Text(viewModel.viewState.titleRewardsType)
                    .font(.PangramSans.bold(FHKSize.size16))
                    .foregroundColor(FHKColor.basicWhite)
                    .padding()
                
                Text(viewModel.viewState.titleInTime)
                    .font(.PangramSans.bold(FHKSize.size16))
                    .foregroundColor(FHKColor.basicWhite)
                    .padding(.horizontal)
                
                FHKTextField(text: $viewModel.viewState.rewardsTime,
                             placeholder: "")
                .onlyIntegers(text: $viewModel.viewState.rewardsTime)
                .padding(.horizontal)
                
                Text(viewModel.viewState.titleInCoins)
                    .font(.PangramSans.bold(FHKSize.size16))
                    .foregroundColor(FHKColor.basicWhite)
                    .padding(.horizontal)
                    .padding(.top)
                
                FHKTextField(text: $viewModel.viewState.rewardsKidsCoin,
                             placeholder: "")
                .onlyIntegers(text: $viewModel.viewState.rewardsKidsCoin)
                .padding(.horizontal)
                
                FHKButtonPrimary(title: viewModel.viewState.titleBtnCreateTask,
                                 state: viewModel.viewState.createTaskButtonState,
                                 mode: .solid,
                                 action: {
                    Task {
                         await viewModel.action(.createTask)
                    }
                })
                .padding(.horizontal)
                .padding(.top, FHKSpace.space32)
            }
            .padding()
        }
        .padding(.top, FHKSpace.space32)
    }
    
    var modalInformationError: some View {
        VStack(alignment: .leading, spacing: FHKSpace.space08) {
            FHKInformationView(message: viewModel.viewState.msnUserError,
                               type: .error,
                               confirmButtonText: viewModel.viewState.titleBtnUnderstood,
                                confirmAction: {
                viewModel.fhkModal.dismiss()
            })
        }
    }
    
    var resultModalSuccess: some View {
        VStack(alignment: .leading, spacing: FHKSpace.space08) {
            FHKInformationView(message: viewModel.viewState.msnCreateTaskSuccess,
                               type: .success,
                               confirmButtonText: viewModel.viewState.titleBtnUnderstood,
                                confirmAction: {
                viewModel.fhkModal.dismiss()
                router.pop()
            })
        }
    }
}

#Preview {
    TaskCreateScreen(viewModel: TaskCreateScreenVM())
}
