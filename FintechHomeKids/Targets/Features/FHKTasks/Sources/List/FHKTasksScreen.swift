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
        FHKScreenContainer {
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
                await viewModel.getParentMail()
                // Upon entering the screen, we let the repository decide (cache vs back)
                await viewModel.action(.fetchTasks(force: false))
            }
        }
    }
    
    var headerChildView: some View {
        HStack {
            Spacer()
            
            VStack(alignment: .leading) {
                Text(viewModel.viewState.taskAvailableTitle)
                    .font(.PangramSans.extraboldItalic(FHKSize.size16))
                    .foregroundStyle(FHKColor.purpleBackground)
                
                Text(viewModel.viewState.taskAvailableDescription)
                    .font(.PangramSans.bold(FHKSize.size12))
                    .foregroundStyle(FHKColor.indigo)
            }
            
            if let imgAvatar =  member?.avatarName.getAvatar {
                AvatarView(image: imgAvatar, size: FHKSize.size48)
            }
        }
    }
    
    var headerParentView: some View {
        HStack {
            Spacer()
            
            VStack(alignment: .leading) {
                Text(viewModel.viewState.taskTitle)
                    .font(.PangramSans.extraboldItalic(FHKSize.size20))
                    .foregroundStyle(FHKColor.purpleBackground)
                
                Text(viewModel.viewState.taskCreateDescription)
                    .font(.PangramSans.bold(FHKSize.size12))
                    .foregroundStyle(FHKColor.indigo)
            }
            
            Spacer()
            AvatarView(name: viewModel.viewState.parentEmail ?? "--", size: FHKSize.size52)
            
            
        }
        .padding(.leading, FHKSpace.space48)
    }
    
    var loadingView: some View {
        LoadingView(msn: viewModel.viewState.msnLoading)
    }
    
    var loadedView: some View {
        VStack {
            HeaderBannerView {
                /// section title bar and icon profile
                if isFromChildSelection {
                    headerChildView
                } else {
                    headerParentView
                }
            }
            .frame(height: FHKSize.size32)
            
            ZStack(alignment: .bottomTrailing) {
                
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 10) {
                        
                        Text(viewModel.viewState.taskCreatedParentDescription)
                            .font(.PangramSans.extraboldItalic(FHKSize.size14))
                            .foregroundColor(FHKColor.indigo.opacity(0.5))
                            .padding(.horizontal)
   
                        ForEach(viewModel.viewState.taskList) { task in
                            CardView { _ in
                                
                                guard let member = self.member, isFromChildSelection else {
                                    return
                                }
                                
                                router.navigate(to: .startTask(taskEntity: task.asPayload,
                                                               memberEntity: member.asPayload))
                            } content: {
                                HStack(spacing: 0) {
                                    
                                    // only display lotties if entry from member profile
                                    if isFromChildSelection {
                                        DescriptionCardView(title: task.name,
                                                            description: task.description)
                                        
                                        makeLottiesView(task: task)
                                    } else {
                                        HStack {
                                            Image(systemName: "square.and.pencil.circle")
                                                .resizable()
                                                .frame(width: FHKSize.size32, height: FHKSize.size32)
                                                .foregroundStyle(FHKColor.yellow)
                                                .padding(.trailing, FHKSpace.space08)
                                            
                                            DescriptionCardView(title: task.name,
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
    }
    
    @ViewBuilder
    private func makeLottiesView(task: FHKTaskEntity) -> some View {
        HStack(spacing: 0) {
            VStack {
                LottieView(animationName: Lotties.coin,
                           loopMode: .loop,
                           contentMode: .scaleAspectFit)
                .frame(height: FHKSize.size120)
                   
                Text("\(task.coinsGranted)")
                    .font(.PangramSans.bold(FHKSize.size24))
                    .foregroundColor(FHKColor.warning)
                    .padding(.horizontal, FHKSpace.space08)
                    .padding(.top, -40)
            }
            .padding(.top, -30)
            
            Spacer()
            VStack {
                LottieView(animationName: Lotties.hours,
                           loopMode: .loop,
                           contentMode: .scaleAspectFit)
                    .frame(height: 80)
                    .padding(.top, -20)
                    
                Text("\(task.timeGranted)")
                    .font(.PangramSans.bold(FHKSize.size24))
                    .foregroundColor(FHKColor.indigo.opacity(0.6))
                    .padding(.horizontal, FHKSpace.space08)
                    .padding(.top, -20)
            }
            
        }
    }
}

// Para ver unicamente la pantalla
#Preview("Design / Children UI") {
    FHKPreview {
        FHKTasksScreen(member: FHKMemberEntity.previewItem,
                       isFromChildSelection: true)
            .withPreviewRouter()
    }
}

#Preview("Design / Perents UI") {
    FHKPreview {
        FHKTasksScreen(member: FHKMemberEntity.previewItem,
                       isFromChildSelection: false)
            .withPreviewRouter()
    }
}
