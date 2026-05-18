//
//  TaskStartScreen.swift
//  fintechKids
//
//  Created by Fredy Leon on 21/3/26.
//

import SwiftUI
import FHKCore
import FHKDesignSystem
import FHKDomain

struct TaskStartScreen<VM: TaskStartScreenVM>: View {
    @State var viewModel: VM
    @NavigationRouterWrapper<Routes> private var router
    var task: TaskEntity
    var member: MemberEntity
    
    var body: some View {
        ScreenContainer(title: Routes.Titles.tasks) {
            switch viewModel.viewState.startTaskState {
            case .loaded, .confirmation, .validation:
                loadedView
                
            case .loading:
                loadingView
            }
        }
        .onChange(of: viewModel.viewState.startTaskState) { _, state in
            switch state {
            case .validation:
                viewModel.fhkModal.show(
                    onDismiss: {
                        viewModel.viewState.startTaskState = .loaded
                    }, content: {
                        ValidatePinModalView(viewModel: viewModel)
                    }
                )
                
            case .confirmation:
                viewModel.fhkModal.show(
                    onDismiss: {
                        viewModel.viewState.startTaskState = .loaded
                    }, content: {
                        proccessRewardModal
                    }
                )
            default:
                break
            }
        }
    }
    
    var loadedView: some View {
        VStack(alignment: .leading) {
            descriptionView
            Spacer()
            
            buttonTimerView
            Spacer()
            
            buttonsControlView
            .padding()
        }
        .padding(.horizontal, 24)
    }
    
    var loadingView: some View {
        LoadingView(msn: viewModel.viewState.msnLoading)
    }
    
    var descriptionView: some View {
        VStack(alignment: .leading) {
            Text("\(viewModel.viewState.titleDescription):")
                .font(.PangramSans.bold(FHKSize.size24))
                .foregroundColor(FHKColor.warning)
            
            Text("\(task.name)")
                .multilineTextAlignment(.leading)
                .font(.PangramSans.bold(FHKSize.size24))
                .foregroundColor(FHKColor.stone.opacity(0.7))
            
            Text("\(viewModel.viewState.titleRewards):")
                .font(.PangramSans.bold(FHKSize.size24))
                .foregroundColor(FHKColor.warning)
                .padding(.top)
            
            HStack(spacing: FHKSize.size08) {
                FHKRewardTypeView(value: "\(task.timeGranted)",
                                  type: .time)
                Text("/")
                    .font(.PangramSans.bold(FHKSize.size24))
                    .foregroundColor(FHKColor.gray)
                
                FHKRewardTypeView(value: "\(task.coinsGranted)",
                                  type: .coins)
            }
        }
        .padding(.top)
    }
    
    var buttonTimerView: some View {
        HStack {
            Spacer()
            
            FHKWatchButton(startTitle: viewModel.viewState.titleStart,
                           stopTitle: viewModel.viewState.titleStop,
                           resetTitle: viewModel.viewState.titleReset,
                           onStop: { dedicatedTime in
                viewModel.viewState.dedicatedTimeTask = dedicatedTime
            })
            
            Spacer()
        }
    }
    
    var buttonsControlView: some View {
        HStack {
            FHKButtonPrimary(title: viewModel.viewState.titleCancel,
                             state: .enabled,
                             mode: .glass(.clearWithInteractive),
                             action: {
                router.pop()
            })
            
            FHKButtonPrimary(title: viewModel.viewState.titleApproved,
                             state: viewModel.viewState.buttonAprovalState,
                             mode: .solid,
                             action: {
                viewModel.viewState.startTaskState = .validation
            })
        }
    }
    
    var proccessRewardModal: some View {
        VStack(alignment: .leading, spacing: FHKSpace.space08) {
            
            Text(viewModel.viewState.titleHowReceiveReward)
                .font(.PangramSans.bold(FHKSize.size20))
                .foregroundColor(FHKColor.lunarSand)
                .padding(.top)
            
            HStack(spacing: FHKSize.size08) {
                FHKRewardTypeView(value: "\(task.timeGranted)",
                                  type: .time)
                Text("/")
                    .font(.PangramSans.bold(FHKSize.size24))
                    .foregroundColor(FHKColor.gray)
                
                FHKRewardTypeView(value: "\(task.coinsGranted)",
                                  type: .coins)
            }
            
            FHKRadioGroupField(
                title: "",
                options: viewModel.viewState.rewardsOptions,
                selection: $viewModel.viewState.selectedRewardType,
                onSelectionChanged: { _ in }
            )
            .padding(.bottom)
            
            VStack {
                FHKButtonPrimary(title: viewModel.viewState.titleSendSavings,
                                 state: .enabled,
                                 mode: .glass(.clearWithInteractive),
                                 action: {
                    goToCollectReward(type: .sendToSavings)
                })
                
                FHKButtonPrimary(title: viewModel.viewState.titleChangeRewards,
                                 state: .enabled,
                                 mode: .glass(.clearWithInteractive),
                                 action: {
                    goToCollectReward(type: .changeByRewards)
                })
                
                FHKButtonPrimary(title: viewModel.viewState.titleAssignMyGoals,
                                 state: .enabled,
                                 mode: .glass(.clearWithInteractive),
                                 action: {
                    goToCollectReward(type: .assignToGoal)
                })
            }
        }
    }
    
    private func goToCollectReward(type: ReceiveFormType) {
        guard let selectedRewardType = viewModel.viewState.selectedRewardType else {
            viewModel.displayNotification(message: viewModel.viewState.collectTypeError,
                                          type: .error)
            return
        }
        let collectReward = CollectRewardEntity(task: task,
                                                receiveRewardType: type,
                                                rewardType: selectedRewardType)
        viewModel.fhkModal.dismiss()
        router.navigate(to: .collectReward(collectReward, member))
    }
}

#Preview {
    PreviewContainer {
        TaskStartScreen(viewModel: TaskStartScreenVM(),
                        task: TaskEntity(
            createdAt: "2026-03-13 05:16:12.976+00",
            name: "Limpiar los sabados su cuarto y ademas ayudar con ...",
            description: "Limpiar cuarto completamente bien, con todo ordenado y la ropa sucia en su lugar",
            timeGranted: "2 horas",
            coinsGranted: 100,
            emailParent: "email@gmail.com"
                        ), member: MemberEntity(id: UUID(),
                                                emailParent: "email@gmail.com",
                                                memberName: "Isaac",
                                                familyName: "Leon's",
                                                avatarName: "boy_6"))
    }
}
