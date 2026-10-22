//
//  FHKMemberDetailScreen.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 15/9/26.
//

import SwiftUI
import FHKCore
import FHKDesignSystem
import FLibUtils
import FHKDomain

public struct FHKMemberDetailScreen: View {
    @State private var viewModel: FHKMemberDetailScreenVM
    @State private var selectedMenuTabBarIndex = 0
    @Router private var router: NavigationRouter<RoutesDestination>
    private var memberID: UUID
    private var myGoals: [FHKGoalMemberEntity]
    
    public init(_ memberID: UUID, myGoals: [FHKGoalMemberEntity] = []) {
        self._viewModel = State(initialValue: FHKMemberDetailScreenVM())
        self.memberID = memberID
        self.myGoals = myGoals
    }
    
    public var body: some View {
        FHKScreenContainer {
            switch viewModel.viewState.memberState {
                
            case .loading:
                loadingView
                
            case .finish, .loaded:
                loadedView
            }
        }
        .observeLanguage()
        .onAppear {
            Task {
                await viewModel.action(.getMemberBy(memberId: memberID))
            }
        }
    }
    
    var loadingView: some View {
        LoadingView(msn: viewModel.viewState.msnLoading)
    }
    
    var loadedView: some View {
        VStack(spacing: 0) {
            VStack {
                HeaderBannerView {
                    
                    // section content avatar
                    headerContentView
                    
                    // section card balance
                    balanceView
                    
                    // section button task
                    buttonTaskView
                }
                
                ScrollView {
                    VStack {
                        // section Goals
                        goalsView
                        // section Rewards
                        rewardsView
                    }
                }
                .padding(.top, -120)
                .frame(maxWidth: .infinity)
            }
            .refreshable {
                await viewModel.action(.getBalanceMember(memberId: memberID))
            }
            
            Spacer()
            if !viewModel.viewState.menuTabBarItems.isEmpty {
                bottomBarView
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
    
    private var headerContentView: some View {
        HStack {
            Spacer()
            AvatarView(
                image: viewModel.viewState.avatarUser,
                size: FHKSize.size52
            )
            
            VStack(alignment: .leading, spacing: 2) {
                Text("\(viewModel.viewState.titleWelcome),")
                    .font(.PangramSans.bold(FHKSize.size12))
                    .foregroundColor(.white.opacity(0.8))
                
                Text("\(viewModel.viewState.member?.memberName ?? "")!")
                    .font(.PangramSans.bold(FHKSize.size20))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            levelView
        }
        .padding(.leading, FHKSpace.space48)
    }
    
    private var levelView: some View {
        VStack(alignment: .trailing, spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: "circle.fill")
                    .foregroundColor(.yellow)
                Text("\(viewModel.viewState.balance?.coinsObtained ?? 740)")
                    .font(.PangramSans.bold(FHKSize.size16))
                    .foregroundColor(.white)
            }
            Text("\(viewModel.viewState.titleLevel)")
                .font(.PangramSans.bold(FHKSize.size12))
                .foregroundColor(.white.opacity(0.8))
        }
    }
    
    private var balanceView: some View {
        CardView { _ in } content: {
            HStack {
                
                FHKCoinBadge(
                    amount: "\(viewModel.viewState.balance?.coinsObtained ?? 0)")
                
                Spacer()
                
                FHKTimeBadge(
                    amount: "\(viewModel.viewState.balance?.timeObtained ?? "0")")
                
            }
        }
    }
    
    private var buttonTaskView: some View {
        FHKButtonPrimary(
            title: viewModel.viewState.titleViewTask.uppercased(),
            textColor: FHKColor.basicBlack,
            state: .enabled,
            mode: .glass(.clearWithInteractive),
            action: {
                router.navigate(to: .tasks(
                    member: viewModel.viewState.member?.asPayload,
                    isFromChildSelection: true
                ))
            }
        )
        .padding(.horizontal)
    }
    
    private var goalsView: some View {
        VStack {
            HStack {
                Text(viewModel.viewState.titleMyGoals.uppercased())
                    .font(.PangramSans.light(FHKSize.size20))
                    .foregroundStyle(FHKColor.basicBlack)
                    .padding(.leading, FHKSpace.space12)
                
                Spacer()
            }
            
            // Aquí irán las tarjetas (Savings Goal)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: FHKSpace.space16) {
                    ForEach(myGoals) { goal in
                        
                        GoalCardView(
                            id: goal.goalId,
                            state: .loaded,
                            current: Double(goal.accumulatedValue),
                            total: Double(goal.rewardsSystemValue),
                            title: goal.nameGoal,
                            workType: "Hours"
                        )
                        .padding(.horizontal, FHKSpace.space16)
                        .frame(width: UIScreen.main.bounds.width)
                    }
                }
            }
        }
    }
    
    private var rewardsView: some View {
        VStack {
            HStack {
                Text(viewModel.viewState.titleMyRewards.uppercased())
                    .font(.PangramSans.light(FHKSize.size20))
                    .foregroundStyle(FHKColor.basicBlack)
                    .padding(.top, FHKSpace.space24)
                    .padding(.leading, FHKSpace.space12)
                
                Spacer()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(myGoals) { goal in
                        
                        let gradient = viewModel.viewState.cardGradients[goal.goalId % viewModel.viewState.cardGradients.count]
                        
                        RewardCardView(id: 1,
                                       state: .loaded,
                                       title: "Go to Park",
                                       bgGradient: gradient
                        )
                        
                        .padding(.horizontal, FHKSpace.space08)
                    }
                }
            }
        }
    }
    
    private var bottomBarView: some View {
        FHKBottomBarContainer(items: viewModel.viewState.menuTabBarItems,
                              selectedIndex: $selectedMenuTabBarIndex) { item in
            print("Click en \(item.title)")
        }
    }
}

// Para ver unicamente la pantalla
#Preview("Design / Isolated UI") {
    FHKPreview {
        FHKMemberDetailScreen(UUID(),
                              myGoals: FHKGoalMemberEntity.previewItem(2))
            .withPreviewRouter()
    }
}
