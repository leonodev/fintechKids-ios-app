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
                Task {
                    
                    //                            await viewModel.action(.registerUser)
                }
            })
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
