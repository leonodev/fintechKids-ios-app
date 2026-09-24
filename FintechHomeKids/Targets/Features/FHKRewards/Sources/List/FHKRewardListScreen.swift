//
//  FHKRewardListScreen.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 24/9/26.
//

import SwiftUI
import FHKCore
import FHKDesignSystem
import FHKDomain

public struct FHKRewardListScreen: View {
    @State private var viewModel: FHKRewardListScreenVM
    @Router private var router: NavigationRouter<RoutesDestination>
    
    public init() {
        self._viewModel = State(initialValue: FHKRewardListScreenVM())
    }
    
    public var body: some View {
        FHKScreenContainer(title: viewModel.viewState.rewardsTitle) {
            switch viewModel.viewState.rewardListState {
               
            case .empty:
                emptyView
                
            case .loading:
                loadingView
                
            case .finish, .loaded:
                loadedView
            }
        }
        .onAppear {
            Task {
                // Upon entering the screen, we let the repository decide (cache vs back)
                await viewModel.action(.fetchRewards(force: false))
            }
        }
    }
    
    var emptyView: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(alignment: .center, spacing: 0) {
                    
                    LottieView(animationName: Lotties.emptySearch, loopMode: .playOnce)
                        .frame(width: 300, height: 300)
                    
                    Text(viewModel.viewState.msnRewardsEmpty)
                        .multilineTextAlignment(.center)
                        .font(.PangramSans.bold(FHKSize.size20))
                        .foregroundColor(FHKColor.gray)
                        .padding(.horizontal)
                }
            }
            .refreshable {
               // await viewModel.action(.fetchGoals(force: true))
            }
            
            buttonCreteGoal
                .padding(25)
        }
    }
    
    var buttonCreteGoal: some View {
        Button {
            //@comentado
            //router.navigate(to: .createReward)
        } label: {
            FHKButtomPlus()
        }
    }
    
    var loadingView: some View {
        LoadingView(msn: viewModel.viewState.msnLoading)
    }
    
    var loadedView: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                LazyVStack(alignment: .center, spacing: 0) {
                    ForEach(viewModel.viewState.rewardList) { reward in
                        FHKCardView { _ in
                            print("Navegando a ....: ")
                        } content: {
                            
                            VStack(alignment: .leading) {
                                FHKDescriptionCardView(title: reward.name.uppercased(), description: "")
                                
                                Text("Para alcanzar esta meta, necesitas:")
                                    .font(.PangramSans.bold(FHKSize.size12))
                                    .foregroundColor(FHKColor.lunarSand)
                                    .padding(.top, FHKSpace.space04)
                                
                                HStack(spacing: 0) {
                                    
                                    LottieView(animationName: Lotties.party,
                                               loopMode: .loop,
                                               contentMode: .topLeft)
                                    
                                    Spacer()
                                    VStack(alignment: .leading) {
                                        Text("\(reward.timeRequiered.capitalized) \(viewModel.viewState.titleHours)")
                                            .font(.PangramSans.bold(FHKSize.size24))
                                            .foregroundColor(FHKColor.warning)
                                        
                                        Text("\(reward.coinsRequiered) KidsCoins")
                                            .font(.PangramSans.bold(FHKSize.size24))
                                            .foregroundColor(FHKColor.lunarSand.opacity(0.7))
                                    }
                                    .padding(.top, 16)
                                }
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
            
            buttonCreteGoal
                .padding(25)
        }
    }
}

// Para ver unicamente la pantalla
#Preview("Design / Isolated UI") {
    FHKPreview {
        FHKRewardListScreen()
            .withPreviewRouter()
    }
}

