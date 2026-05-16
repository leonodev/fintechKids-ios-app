//
//  HomeScreen.swift
//  fintechKids
//
//  Created by Fredy Leon on 17/1/26.
//

import SwiftUI
import FHKCore
import FHKDesignSystem
import FHKDomain

struct HomeScreen<VM: HomeScreenVM>: View {
    @NavigationRouterWrapper<Routes> private var router
    @State var viewModel: VM
    @State private var showPermissions = false
    @State private var selectedMenuTabBarIndex = 0
    
    var body: some View {
        ScreenContainer(title: Routes.Titles.home) {
            
            VStack(alignment: .leading, spacing: 0) {
                headerView
                
                membersView
                
                rewardsCollectedView
                
                goalMemberFamilyView
                
                Spacer()
                botomBarView
            }
            .fullScreenCover(isPresented: $showPermissions) {
                PermissionRequestView(provider: viewModel.fhkCameraPermission)
            }
        }
        .background(FHKColor.indigo)
        .onAppear {
            Task {
                await viewModel.getParentMail()
                async let fetchMembers: () = viewModel.action(.fetchMemberFamily(force: false))
                async let fetchRewards: () = viewModel.action(.fetchRewardsCollected(force: false))
                async let fetchGoalMembers: () = viewModel.action(.fetchMemberGoals(force: false))
                await _ = (fetchMembers, fetchRewards, fetchGoalMembers)
            }
            
            //                if camaraPermissionManager.status != .authorized {
            //                    showPermissions = true
            //                }
        }
    }

    var headerView: some View {
        HStack {
            Text(viewModel.viewState.titleMemberFamily)
                .font(.PangramSans.bold(FHKSize.size12))
                .colorDegradeStyle(startColor: FHKColor.pastelPink,
                                   endColor: .gray.opacity(0.8))
            
            Spacer()
            
            AvatarView(name: viewModel.viewState.parentEmail ?? "--", size: FHKSize.size52)
                .onTapGesture {
                    router.navigate(to: .profile)
                }
        }
        .padding(.horizontal)
    }
    
    var membersView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: FHKSpace.space16) {
                switch viewModel.viewState.familyState {
                case .skeleton:
                    FHKMemberItem.skeletons(count: 3)
                    
                case .loaded, .disabled:
                    ForEach(viewModel.familyMembersList) { member in
                        getMemberLoaded(member: member)
                    }
                    
                case .error:
                    FHKMemberItem(state: .defaultDataError)
                }
            }
            .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal)
    }
    
    var rewardsCollectedView: some View {
        VStack(alignment: .leading) {
            GradientDivider()
            
            Text(viewModel.viewState.titleRewardsCollected)
                .font(.PangramSans.bold(FHKSize.size12))
                .padding(.leading, FHKSpace.space08)
                .padding(.top, FHKSpace.space16)
                .colorDegradeStyle(startColor: FHKColor.pastelPink,
                                   endColor: .gray.opacity(0.8))
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: FHKSpace.space16) {
                    switch viewModel.viewState.rewardsState {
                        
                    case .skeleton:
                        FHKRewardCollectCard.skeletons(count: 3, style: .glass)
                        
                    case .loaded, .disabled:
                        ForEach(viewModel.rewardsCollectedList) { ticket in
                            getRewardCollectCardLoaded(ticket: ticket)
                        }
                        
                    case .error:
                        FHKRewardCollectCard(state: .defaultDataError, style: .glass)
                    }
                }
            }
            .frame(height: FHKSize.size132)
            .padding(.horizontal, FHKSpace.space08)
        }
        .padding(.top, FHKSpace.space16)
    }
    
    var goalMemberFamilyView: some View {
        VStack(alignment: .leading) {
            GradientDivider()
            
            Text(viewModel.viewState.msnGoalsInCurse)
                .font(.PangramSans.bold(FHKSize.size16))
                .padding(.leading, FHKSpace.space08)
                .padding(.top, FHKSpace.space16)
                .colorDegradeStyle(startColor: FHKColor.pastelPink,
                                   endColor: .gray.opacity(0.8))
                     
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: FHKSpace.space16) {
                    switch viewModel.viewState.goalMemberState {
                        
                    case .skeleton:
                        FHKGoalCardView.skeletons(count: 3)
                        
                    case .loaded, .disabled:
                        ForEach(viewModel.goalMemberList) { goal in
                            FHKGoalCardView(id: goal.goalId,
                                            state: viewModel.viewState.goalMemberState,
                                            current: Double(goal.accumulatedValue),
                                            total: Double(goal.rewardsSystemValue),
                                            title: goal.nameGoal.uppercased(),
                                            workType: goal.rewardsSystemType,
                                            action: { id in
                            })
                        }
                        
                    case .error:
                        FHKGoalCardView.error(msn: viewModel.viewState.titleDataUnavailable)
                    }
                }
            }
            .frame(height: FHKSize.size132)
            .padding(.horizontal, FHKSpace.space08)
            
            GradientDivider()
        }
        .padding(.top, FHKSpace.space16)
    }
    
    var botomBarView: some View {
        ZStack {
            VStack {
                Spacer()
                
                FHKBottomBarContainer(items: viewModel.viewState.menuTabBarItems, selectedIndex: $selectedMenuTabBarIndex) { item in
                    print("Click en \(item.title)")
                } floatingButton: {
                    floatMenuView
                }
            }
        }
        .padding(.bottom, -32)
    }
    
    var floatMenuView: some View {
        HStack {
           Spacer()
            
            FloatMenu(options: viewModel.viewState.options,
                      callback: { menu in
                switch menu {
                case .members:
                    router.navigate(to: .members)
                    
                case .tasks:
                    router.navigate(to: .tasks(isFromChildSelection: false, nil))
                    
                case .goals:
                    router.navigate(to: .goals)
                    
                default:
                    break
                }
                print(index)
            })
            
            Spacer()
        }
    }
}

private extension HomeScreen {
    
    func getMemberLoaded(member: MemberEntity) -> FHKMemberItem {
        FHKMemberItem(id: viewModel.getId(member: member),
                      avatarName: viewModel.getAvatarMember(member: member),
                      nameMember: viewModel.getNameMember(member: member),
                      state: viewModel.viewState.getStateItemMemberComponent(
                        memberName: viewModel.getNameMember(member: member),
                        avatarName: viewModel.getAvatarMember(member: member)
                      ),
                      action: { _ in
            router.navigate(to: .memberDetail(member))
        })
    }
    
    func getRewardCollectCardLoaded(ticket: RewardCollectedEntity) -> FHKRewardCollectCard {
        FHKRewardCollectCard(state: .loaded,
                             style: .glass,
                             id: ticket.id,
                             memberName: ticket.member.memberName,
                             avatarName: ticket.member.avatarName,
                             taskName: ticket.nameTask,
                             rewardName: ticket.nameReward,
                             titleBtnPay: viewModel.viewState.titleBtnPay)
    }
}

#Preview {
    VStack {
        HomeScreen(viewModel: HomeScreenVM())
    }
    .background(FHKColor.indigo)
}
