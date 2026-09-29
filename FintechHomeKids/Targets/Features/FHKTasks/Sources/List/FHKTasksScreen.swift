//
//  FHKTasksScreen.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 27/9/26.
//

import SwiftUI
import FHKCore
import FHKDesignSystem
import FHKDomain

public struct FHKTasksScreen: View {
    @State private var viewModel: FHKTasksScreenVM
    @Router private var router: NavigationRouter<RoutesDestination>
    var member: FHKMemberEntity?
    var isFromChildSelection: Bool
    
    public init(member: FHKMemberEntity?, isFromChildSelection: Bool) {
        self._viewModel = State(initialValue: FHKTasksScreenVM())
        self.member = member
        self.isFromChildSelection = isFromChildSelection
    }
    
    public var body: some View {
        FHKScreenContainer(title: viewModel.viewState.taskTitle) {
            switch viewModel.viewState.taskState {
                
            case .loading:
                loadingView
                
            case .finish, .loaded:
                loadedView
            }
        }
        .observeLanguage()
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
                            
                            router.navigate(to: .startTask(taskEntity: task.asPayload,
                                                           memberEntity: member.asPayload))
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
                                            .foregroundStyle(FHKColor.yellow)
                                            .padding(.trailing, FHKSpace.space08)
                                        
                                        FHKDescriptionCardView(title: task.name,
                                                               description: task.description)
                                    }
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
                    router.navigate(to: .createTasks)
                } label: {
                    FHKButtomPlus()
                }
                .padding(25)
            }
        }
    }
    
    @ViewBuilder
    private func makeLottiesView(task: FHKTaskEntity) -> some View {
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

// Para ver unicamente la pantalla
#Preview("Design / Isolated UI") {
    FHKPreview {
        FHKTasksScreen(member: FHKMemberEntity.previewItem,
                       isFromChildSelection: true)
            .withPreviewRouter()
    }
}

