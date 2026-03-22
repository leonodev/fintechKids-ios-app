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
    
    var body: some View {
        ScreenContainer(title: Routes.tasks.title) {
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
                            router.navigate(to: .startTask(task))
                        } content: {
                            VStack(alignment: .leading, spacing: 0) {
                                FHKDescriptionCardView(title: task.name, description: task.description)
                                
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
                        .padding()
                    }
                }
                .padding(.top)
            }
            .refreshable {
                await viewModel.action(.fetchTasks(force: true))
            }

            Button {
                router.navigate(to: .createTask)
            } label: {
                ZStack {
                    Circle()
                        .foregroundColor(.indigo)
                        .frame(width: 70, height: 70)
                        .shadow(radius: 5)
                    
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .font(.title)
                }
            }
            .padding(25)
        }
    }
}

#Preview {
    let vm = TasksScreenVM()
    
    vm.viewState.taskList = [
        TaskEntity(
            createdAt: "2026-03-13 05:16:12.976+00",
            name: "Limpiar los sabados...",
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
