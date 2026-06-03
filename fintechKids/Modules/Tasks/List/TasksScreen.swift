//
//  TasksScreen.swift
//  fintechKids
//
//  Created by Fredy Leon on 19/12/25.
//

import SwiftUI
import FHKCore
import FHKDesignSystem
import FHKDomain

struct TasksScreen<VM: TasksScreenVM>: View {
    @State var viewModel: VM
    @NavigationRouterWrapper<Routes> private var router
    var member: MemberEntity?
    var isFromChildSelection: Bool = false
    
    var body: some View {
        ScreenContainer(title: Routes.Titles.tasks) {
            switch viewModel.viewState.taskState {
                
            case .loading:
                loadingView
                
            case .finish, .loaded:
                loadedView
            }
        }
        .onAppear {
            Task {
                // Upon entering the screen, we let the repository decide (cache vs back)
                await viewModel.action(.fetchTasks(force: false))
            }
        }
    }
    
    var loadingView: some View {
        LoadingView(msn: viewModel.viewState.msnLoading)
    }
    
    var loadedView: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                LazyVStack(alignment: .center, spacing: 10) {
                    ForEach(viewModel.viewState.taskList) { task in
                        FHKCardView { _ in
                            guard let member = self.member, isFromChildSelection else {
                                return
                            }
                            
                            router.navigate(to: .startTask(task, member))
                        } content: {
                            VStack(alignment: .leading, spacing: 0) {
 
                                // only display lotties if entry from member profile
                                if isFromChildSelection {
                                    FHKDescriptionCardView(title: task.name,
                                                           description: task.description)
                                    
                                    makeLottiesView(task: task)
                                } else {
                                    HStack {
                                        Image(systemName: "paperclip")
                                            .resizable()
                                            .frame(width: FHKSize.size32, height: FHKSize.size32)
                                            .colorDegradeStyle(startColor: FHKColor.yellow, endColor: FHKColor.warning)
                                            .padding(.trailing, FHKSpace.space08)
                                        
                                        Text(task.name)
                                            .font(.PangramSans.bold(FHKSize.size16))
                                            .foregroundColor(FHKColor.basicWhite)
                                        
                                        Spacer()
                                        
                                        VStack(alignment: .trailing) {
                                            HStack {
                                                viewModel.viewState.coinSingle
                                                    .resizable()
                                                    .frame(
                                                        width: FHKSize.size28,
                                                        height: FHKSize.size40)
                                                    .padding(.trailing, -FHKSpace.space08)
                                                
                                                Text("+\(task.coinsGranted)")
                                                    .font(.PangramSans.bold(FHKSize.size20))
                                                    .colorDegradeStyle(startColor: FHKColor.yellow, endColor: FHKColor.warning)
                                            }
                                            
                                            Text(viewModel.viewState.titleInCoins)
                                                .font(.PangramSans.bold(FHKSize.size08))
                                                .colorDegradeStyle(startColor: FHKColor.lunarSand, endColor: FHKColor.basicWhite)
                                                .padding(.top, -18)
                                        }
                                    }
                                    
                                    Text(task.description)
                                        .font(.PangramSans.bold(FHKSize.size08))
                                        .foregroundColor(FHKColor.basicWhite.opacity(0.8))
                                        .padding(.leading, FHKSpace.space04)
 
                                    HStack {
                                        
                                        Image(systemName: "clock.fill")
                                            .resizable()
                                            .frame(width: FHKSize.size20,
                                                   height: FHKSize.size20)
                                            .colorDegradeStyle(
                                                startColor: FHKColor.pastelPink,
                                                endColor: FHKColor.lunarSand)
                                        
                                        Text("\(viewModel.viewState.titleInTime): \(task.timeGranted)")
                                            .font(.PangramSans.bold(FHKSize.size16))
                                            .colorDegradeStyle(
                                                startColor: FHKColor.pastelPink,
                                                endColor: FHKColor.lunarSand)
                                    }
                                    .padding(.top)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .refreshable {
                await viewModel.action(.fetchTasks(force: true))
            }

            // only display lotties if entry from member profile
            if !isFromChildSelection {
                Button {
                    router.navigate(to: .createTask)
                } label: {
                    FHKButtomPlus()
                }
                .padding(25)
            }
        }
    }
    
    @ViewBuilder
    private func makeLottiesView(task: TaskEntity) -> some View {
        HStack(spacing: -30) {
            VStack {
                LottieView(animationName: Lotties.coin,
                           loopMode: .loop,
                           contentMode: .scaleAspectFit)
                    .frame(height: 150)
                   
                Text("\(task.coinsGranted)")
                    .font(.PangramSans.bold(FHKSize.size24))
                    .foregroundColor(FHKColor.warning.opacity(0.7))
                    .padding(.horizontal, FHKSpace.space08)
                    .padding(.top, -40)
            }
            .padding(.top, -30)
            
            VStack {
                LottieView(animationName: Lotties.hours,
                           loopMode: .loop,
                           contentMode: .scaleAspectFit)
                    .frame(height: 100)
                    .padding(.top, -15)
                    
                Text("\(task.timeGranted)")
                    .font(.PangramSans.bold(FHKSize.size24))
                    .foregroundColor(FHKColor.stone.opacity(0.7))
                    .padding(.horizontal, FHKSpace.space08)
                    .padding(.top, -20)
            }
        }
    }
}

#Preview {
    let vm = TasksScreenVM()
    
    vm.viewState.taskList = [
        TaskEntity(
            createdAt: "2026-03-13 05:16:12.976+00",
            name: "Limpiar los sabados",
            description: "Limpiar cuarto completamente bien, con todo ordenado y la ropa sucia en su lugar",
            timeGranted: "2 horas",
            coinsGranted: 100,
            emailParent: "email@gmail.com"
        )
    ]
    
    // 2. Devolvemos la vista dentro de tu contenedor
    return PreviewContainer {
        TasksScreen(viewModel: vm)
    }
}
