//
//  GoalListScreen.swift
//  fintechKids
//
//  Created by Fredy Leon on 20/3/26.
//

import SwiftUI
import FHKCore
import FHKDesignSystem
import FHKDomain

struct GoalListScreen<VM: GoalListScreenVM>: View {
    @State var viewModel: VM
    @NavigationRouterWrapper<Routes> private var router
    
    var body: some View {
        ScreenContainer(title: Routes.goals.title) {
            switch viewModel.viewState.goalListState {
               
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
                await viewModel.action(.fetchGoals(force: false))
            }
        }
    }
    
    var emptyView: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(alignment: .center, spacing: 0) {
                    
                    LottieView(animationName: Lotties.emptySearch, loopMode: .playOnce)
                        .frame(width: 300, height: 300)
                    
                    Text(viewModel.viewState.msnGoalEmpty)
                        .multilineTextAlignment(.center)
                        .font(.PangramSans.bold(FHKSize.size20))
                        .foregroundColor(FHKColor.gray)
                        .padding(.horizontal)
                }
            }
            .refreshable {
                await viewModel.action(.fetchGoals(force: true))
            }
            
            buttonCreteGoal
                .padding(25)
        }
    }
    
    var loadingView: some View {
        LoadingView(msn: viewModel.viewState.msnLoading)
    }
    
    var loadedView: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                LazyVStack(alignment: .center, spacing: 0) {
                    ForEach(viewModel.viewState.goalList) { goal in
                        FHKCardView { _ in
                            print("Navegando a ....: ")
                        } content: {
                            VStack(alignment: .leading) {
                                FHKDescriptionCardView(title: goal.name.uppercased(), description: "")
                                
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
                                    
                                    VStack(alignment: .leading) {
                                        Text("\(goal.value)")
                                            .font(.PangramSans.bold(FHKSize.size24))
                                            .foregroundColor(FHKColor.warning)
                                        
                                        Text("\(goal.measureType.capitalized)")
                                            .font(.PangramSans.bold(FHKSize.size24))
                                            .foregroundColor(FHKColor.lunarSand.opacity(0.7))
                                        
                                        Text(viewModel.viewState.getMassageGoalCard(measureType: goal.measureType))
                                            .font(.PangramSans.bold(FHKSize.size16))
                                            .foregroundColor(FHKColor.gray)
                                            .padding(.top, 8)
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
                await viewModel.action(.fetchGoals(force: true))
            }
            
            buttonCreteGoal
                .padding(25)
        }
    }
    
    var buttonCreteGoal: some View {
        Button {
            router.navigate(to: .createGoal)
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
    }
}

#Preview {
    PreviewContainer {
        let vm = GoalListScreenVM()
        
        vm.viewState.goalList = [
            GoalEntity(expirationDate: "2026-03-20 20:24:21.568999+00",
                       name: "Name",
                       emailParent: "email@gmail.com",
                       value: 2000,
                       measureType: "coins",
                       status: .inCurse),
            
            GoalEntity(expirationDate: "2026-03-20 20:24:21.568999+00",
                       name: "Name",
                       emailParent: "email@gmail.com",
                       value: 3,
                       measureType: "hours",
                       status: .inCurse)
        ]
        
        return PreviewContainer {
            GoalListScreen(viewModel: vm)
        }
    }
}
