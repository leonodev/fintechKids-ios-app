//
//  TasksScreen.swift
//  fintechKids
//
//  Created by Fredy Leon on 19/12/25.
//

import SwiftUI
import FHKCore
import FHKDesignSystem
import FHKUtils
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
                LazyVStack(alignment: .leading, spacing: 10) {
                    ForEach(viewModel.viewState.taskList) { task in
                        FHKCardView { _ in
                            print("Navegando al perfil del usuario: ")
                        } content: {
                            HStack {
                                VStack(alignment: .leading, spacing: 15) {
                                    FHKDescriptionCardView(title: task.name, description: task.description)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 15) {
                                    FHKRewardTypeView(value: task.timeGranted, type: .time)
                                    FHKRewardTypeView(value: "\(task.coinsGranted)", type: .coins)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    Color.clear.frame(height: 80)
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
    TasksScreen(viewModel: TasksScreenVM())
}



