//
//  RewardCollectScreen.swift.swift
//  fintechKids
//
//  Created by Fredy Leon on 25/3/26.
//

import SwiftUI
import FHKCore
import FHKDesignSystem
import FHKDomain

struct RewardCollectScreen<VM: RewardCollectScreenVM>: View {
    @NavigationRouterWrapper<Routes> private var router
    @State private var isAcceptConditions: Bool = false
    @State var viewModel: VM
    @State private var selectedGoalID: Int?
    var collectEntity: CollectRewardEntity
    var memberEntity: MemberEntity
    
    var body: some View {
        ScreenContainer(title: Routes.Titles.collectReward) {
            switch viewModel.viewState.collectState {
               
            case .loading:
                loadingView
                
            case .finish, .loaded:
                loadedView
            }
        }
        .onChange(of: viewModel.viewState.collectState) { _, state in
            switch state {
            case .finish(let result):
                let isSuccess = (result == .success)
                viewModel.fhkModal.show(onDismiss: {},
                                        content: {
                    modalInformationView(isSuccess: isSuccess)
                })
            default:
                break
            }
        }
        .onAppear {
            Task {
                await viewModel.action(.fetchBalance(memberId: memberEntity.id))
                await viewModel.action(.fetchGoals(force: true))
                await viewModel.action(.fetchRewards(force: true))
            }
        }
    }
    
    var loadingView: some View {
        LoadingView(msn: viewModel.viewState.msnLoading)
    }
    
    var loadedView: some View {
        VStack {
            switch (collectEntity.receiveRewardType, collectEntity.rewardType) {
                
            case (.sendToSavings, .time):
                FHKTimeBadge(amount: "\(viewModel.viewState.balance?.timeObtained ?? "0")", size: FHKSize.size24)
                msnInformativeView // Helper para el mensaje
                bannerPathView // Banner
                checkConditionView
                
                Spacer()
                continueButtonView
                
            case (.sendToSavings, .coins):
                FHKCoinBadge(amount: "\(viewModel.viewState.balance?.coinsObtained ?? 0)", size: FHKSize.size24)
                msnInformativeView
                bannerPathView // Banner
                checkConditionView
                
                Spacer()
                continueButtonView

            case (.changeByRewards, .time):
                checkEmpty(viewModel.viewState.rewardList, msn: viewModel.viewState.msnRewardsEmpty) {
                    makeRewardsTimeView()
                }

            case (.changeByRewards, .coins):
                checkEmpty(viewModel.viewState.rewardList, msn: viewModel.viewState.msnRewardsEmpty) {
                    makeRewardsCoinView()
                }

            case (.assignToGoal, _):
                checkEmpty(viewModel.viewState.goalList, msn: viewModel.viewState.msnGoalEmpty) {
                    makeGoalsView()
                        .task { await viewModel.action(.filterGoals(model: collectEntity)) }
                }
            }
        }
    }
    
    private var continueButtonView: some View {
        FHKButtonPrimary(title: viewModel.viewState.titleButtonColletTask(collectType: collectEntity.receiveRewardType),
                         textColor: FHKColor.lunarSand,
                         style: .outlined,
                         state: isAcceptConditions ? .enabled : .disabled,
                         mode: .glass(.clear),
                         action: {
            Task {
                switch collectEntity.rewardType {
                case .coins:
                    let balanceWithKidsCoins = BalanceKidsCoinsEntity(memberId: memberEntity.id, coinsObtained: collectEntity.task.coinsGranted)
                    await viewModel.action(.updateCoinsBalance(balance: balanceWithKidsCoins))
                    
                case .time:
                    let balanceWithTime = BalanceTimeEntity(memberId: memberEntity.id, timeObtained: collectEntity.task.timeGranted)
                    await viewModel.action(.updateTimeBalance(balance: balanceWithTime))
                }
            }
        })
        .padding()
    }
    
    @ViewBuilder
    private func checkEmpty<T>(_ list: [T], msn: String, @ViewBuilder content: () -> some View) -> some View {
        if list.isEmpty {
            makeEmptyView(msn: msn)
        } else {
            VStack(alignment: .leading) {
                msnInformativeView
                    .padding(.leading, FHKSpace.space16)
                content()
            }
        }
    }
    
    // MARK: Goals Views
    @ViewBuilder
    private func makeGoalsView() -> some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                LazyVStack(alignment: .center, spacing: 0) {
                    ForEach(viewModel.viewState.goalList) { goal in
                        FHKCardView(data: goal,
                                    isSelected: selectedGoalID == goal.id,
                                    action: { _ in
                            self.selectedGoalID = goal.id
                            viewModel.fhkModal.show(onDismiss: {},
                                                    content: {
                                FHKConfirmationView(message: viewModel.viewState.msnAssigCollectTaskToGoal(collectModel: collectEntity,
                                                                                                           goal: goal),
                                                    confirmButtonText: viewModel.viewState.titleBtnOk,
                                                    cancelButtonText: viewModel.viewState.titleBtnCancel,
                                                    confirmAction: {
                                    Task {
                                        viewModel.fhkModal.dismiss()
                                        guard let goalID = goal.id else { return }
                                        let goalMember = GoalMemberEntity(goalId: goalID,
                                                                          memberId: memberEntity.id,
                                                                          taskWinnedValue: viewModel.getAccumulatedValue(goal: goal,
                                                                                                                         collectReward: collectEntity),
                                                                          rewardsSystemType: goal.measureType,
                                                                          rewardsSystemValue: goal.value)
                                        await viewModel.action(.upsertMemberGoal(goalMember: goalMember))
                                        
                                        let remainingBalance = BalanceRemainingEntity(memberId: memberEntity.id,
                                                                                      collectReward: collectEntity,
                                                                                      goal: goal)
                                        await viewModel.action(.proccessRemainingBalance(remainingBalance))
                                    }
                                },
                                                    cancelAction: {
                                    viewModel.fhkModal.dismiss()
                                })
                            })
                        },
                                    content: {
                            VStack(alignment: .leading) {
                                FHKDescriptionCardView(title: goal.name.uppercased(),
                                                       description: "")
                                
                                ZStack(alignment: .topTrailing) {
                                    HStack(spacing: 0) {
                                        Spacer()
                                        LottieView(animationName: viewModel.viewState.getLottieAnimation(measureType: goal.measureType),
                                                   loopMode: .playOnce,
                                                   contentMode: .topLeft)
                                        .frame(width: 200,
                                               height: viewModel.viewState.getHeightImageCard(measureType: goal.measureType))
                                    }
                                    .padding(.top, -100)
                                    .padding(.trailing, -100)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text("\(goal.value)")
                                        .font(.PangramSans.bold(FHKSize.size24))
                                        .foregroundColor(FHKColor.warning)
                                    
                                    Text(collectEntity.rewardType == .time
                                         ? "\(goal.measureType.capitalized)"
                                         : "Kids\(goal.measureType.capitalized)"
                                    )
                                    .font(.PangramSans.bold(FHKSize.size24))
                                    .foregroundColor(FHKColor.lunarSand.opacity(0.7))
                                    
                                    Text(viewModel.viewState.getMassageGoalCard(measureType: goal.measureType))
                                        .font(.PangramSans.bold(FHKSize.size16))
                                        .foregroundColor(FHKColor.gray)
                                        .padding(.top, 8)
                                }
                                .padding(.top, -50)
                            }
                        })
                        .padding()
                    }
                }
            }
            .refreshable {
                await viewModel.action(.fetchGoals(force: true))
            }
        }
    }
    
    @ViewBuilder
    private func makeEmptyView(msn: String) -> some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(alignment: .center, spacing: 0) {
                    
                    LottieView(animationName: Lotties.emptySearch, loopMode: .playOnce)
                        .frame(width: 300, height: 300)
                    
                    Text(msn)
                        .multilineTextAlignment(.center)
                        .font(.PangramSans.bold(FHKSize.size20))
                        .foregroundColor(FHKColor.gray)
                        .padding(.horizontal)
                }
            }
            .refreshable {
                switch collectEntity.receiveRewardType {
                case .sendToSavings:
                    break
                    
                case .changeByRewards:
                    await viewModel.action(.fetchRewards(force: true))
                    
                case .assignToGoal:
                    await viewModel.action(.fetchGoals(force: true))
                }
            }
        }
    }
    
    // MARK: Rewards Views
    @ViewBuilder
    private func makeRewardsTimeView() -> some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                LazyVStack(alignment: .center, spacing: 0) {
                    ForEach(viewModel.viewState.rewardList) { reward in
                        FHKCardView(data: reward,
                                    isSelected: true,
                                    action: { item in
                                        print(item?.name ?? "-")
                                    },
                                    content: {
                            VStack(alignment: .leading) {
                                FHKDescriptionCardView(title: reward.name.uppercased(),
                                                       description: "")
                                let taskHours = collectEntity.task.timeGranted.asHours
                                let isValid = taskHours >= reward.requiredHours
                                makeRewardItemView(item: reward,
                                                   type: .time,
                                                   isRewardValid: isValid)
                            }
                        })
                        .padding()
                    }
                }
                .padding(.top)
            }
            .refreshable {
                await viewModel.action(.fetchRewards(force: true))
            }
        }
    }
    
    @ViewBuilder
    private func makeRewardsCoinView() -> some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                LazyVStack(alignment: .center, spacing: 0) {
                    ForEach(viewModel.viewState.rewardList) { reward in
                        FHKCardView { _ in } content: {
                            VStack(alignment: .leading) {
                                FHKDescriptionCardView(title: reward.name.uppercased(),
                                                       description: "")
                                let taskCoins = collectEntity.task.coinsGranted
                                let isValid = taskCoins >= reward.coinsRequiered
                                makeRewardItemView(item: reward,
                                                   type: .coins,
                                                   isRewardValid: isValid)
                            }
                        }
                        .padding()
                    }
                }
                .padding(.top)
            }
            .refreshable {
                await viewModel.action(.fetchRewards(force: true))
            }
        }
    }
    
    @ViewBuilder
    private func makeRewardItemView(
        item: RewardEntity,
        type: WorkType,
        isRewardValid: Bool
    ) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: FHKSpace.space08) {
                
                Text(type == .time ? "\(item.timeRequiered)" : "\(item.coinsRequiered) KidsCoins" )
                    .font(.PangramSans.bold(FHKSize.size24))
                    .foregroundColor(isRewardValid
                                     ? FHKColor.warning
                                     : FHKColor.pastelPink.opacity(0.4))
              
                Text(isRewardValid
                     ? viewModel.viewState.msnChangeRewardEnable
                     : viewModel.viewState.msnChangeRewardDisabled)
                .multilineTextAlignment(.leading)
                .font(.PangramSans.bold(FHKSize.size16))
                .foregroundColor(isRewardValid
                                 ? FHKColor.success
                                 : FHKColor.warning)
            }
            .padding(.top, FHKSpace.space08)
            
            Spacer()
            
            LottieView(animationName: Lotties.party,
                       loopMode: isRewardValid ? .loop : .playOnce)
            .frame(width: 100, height: 100)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            guard isRewardValid else { return }
            let collectValue = type == .time
            ? item.timeRequiered
            : "\(item.coinsRequiered) KidsCoins"
            
            viewModel.fhkModal.show(onDismiss: {},
                                    content: {
                FHKConfirmationView(message: "Desea cambiar tus \(collectValue) de esta recompensa por: \(item.name.uppercased())?",
                                    confirmButtonText: "SI",
                                    cancelButtonText: "NO",
                                    confirmAction: {
                    Task {
                        let ticketData = GoldenTicketParamsEntity(
                            recipientName: memberEntity.memberName,
                            taskDescription: collectEntity.task.name,
                            reward: item.name,
                            emailTo: viewModel.parentMail ?? "",
                            memberId: memberEntity.id,
                            claimedValue: collectValue
                        )
                        viewModel.fhkModal.dismiss()
                        await viewModel.action(.collectSendTicketGold(ticket: ticketData))
                    }
                },
                                    cancelAction: {
                    viewModel.fhkModal.dismiss()
                })
            })
        }
    }
    
    @ViewBuilder
    private func modalInformationView(isSuccess: Bool) -> some View {
        VStack(alignment: .leading, spacing: FHKSpace.space08) {
            FHKInformationView(message: isSuccess
                               ? viewModel.viewState.msnColletTaskSuccess(collectType: collectEntity.receiveRewardType)
                               : viewModel.viewState.msnUpdateBalanceFail,
                               type: isSuccess ? .success : .error,
                               confirmButtonText: viewModel.viewState.titleButtonColletTask(collectType: collectEntity.receiveRewardType),
                                confirmAction: {
                viewModel.fhkModal.dismiss()
                router.popTo(.home)
                
                if case .changeByRewards = collectEntity.receiveRewardType,
                   let info = viewModel.viewState.goldenTicket {
                    router.navigate(to: .presentGoldenTicket(info), style: .fullScreenCover)
                }
            })
        }
    }
    
    private var bannerPathView: some View {
        VStack {
            FHKCardView { _ in } content: {
                viewModel.viewState.imageBanner(type: collectEntity.rewardType)
                    .scaledToFit()
            }
            .padding()
        }
    }
    
    private var checkConditionView: some View {
        VStack {
            FHKCheckBox(label: viewModel.viewState.msnChectAcceptCollect,
                        isChecked: $isAcceptConditions)
            .padding(.leading, FHKSpace.space16)
        }
    }
    
    private var msnInformativeView: some View {
        msnInformative(msn: viewModel.viewState.getTitleTypeReceive(collectModel: collectEntity))
    }
    
    @ViewBuilder
    private func msnInformative(msn: String) -> some View {
        Text(msn)
            .font(.PangramSans.bold(FHKSize.size16))
            .foregroundColor(FHKColor.lunarSand.opacity(0.9))
            .padding(.top, FHKSize.size16)
    }
}
