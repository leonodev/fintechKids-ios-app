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
    
    var body: some View {
        ScreenContainer(title: Routes.tasks.title) {
            switch viewModel.viewState.startTaskState {
            case .loaded, .confirmation:
                loadedView
                
            case .loading:
                loadingView
            }
        }
        .onChange(of: viewModel.viewState.startTaskState) { _, state in
            switch state {
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
            
            buttonsView
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
                           resetTitle: viewModel.viewState.titleReset)
            
            Spacer()
        }
    }
    
    var buttonsView: some View {
        HStack {
            FHKButtonPrimary(title: viewModel.viewState.titleCancel,
                             state: .enabled,
                             mode: .glass(.clearWithInteractive),
                             action: {
                Task {
                    //                            await viewModel.action(.registerUser)
                }
            })
            
            FHKButtonPrimary(title: viewModel.viewState.titleApproved,
                             state: .enabled,
                             mode: .solid,
                             action: {
                viewModel.viewState.startTaskState = .confirmation
            })
        }
    }
    
    var proccessRewardModal: some View {
        VStack(alignment: .leading, spacing: FHKSpace.space08) {
            
            FHKRadioGroupField(
                title: "",
                options: viewModel.viewState.rewardsOptions,
                selection: $viewModel.viewState.selectedRewardType,
                onSelectionChanged: { value in
                    print("Se seleccionó: \(value)")
                }
            )
            
            HStack {
                FHKButtonPrimary(title: "Uno",
                                 state: .enabled,
                                 mode: .glass(.clearWithInteractive),
                                 action: {
                })
                
                FHKButtonPrimary(title: "Dos",
                                 state: .enabled,
                                 mode: .glass(.clearWithInteractive),
                                 action: {
                })
                
                FHKButtonPrimary(title: "Tres",
                                 state: .enabled,
                                 mode: .glass(.clearWithInteractive),
                                 action: {
                })
            }
        }
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
        ))
    }
}
