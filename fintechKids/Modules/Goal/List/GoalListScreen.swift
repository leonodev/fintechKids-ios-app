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
    
    var loadingView: some View {
        LoadingView(msn: viewModel.viewState.msnLoading)
    }
    
    var loadedView: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                LazyVStack(alignment: .center, spacing: 10) {
                    ForEach(viewModel.viewState.goalList) { goal in
                        FHKCardView { _ in
                            print("Navegando a ....: ")
                        } content: {
                            VStack(alignment: .leading, spacing: 0) {
                                FHKDescriptionCardView(title: goal.name.uppercased(), description: "")
     
                                HStack(spacing: 0) {
                                    VStack(alignment: .leading) {
                                        Text("\(goal.value)")
                                            .font(.PangramSans.bold(FHKSize.size24))
                                            .foregroundColor(FHKColor.warning.opacity(0.7))
                                             
                                        Text("\(goal.measureType.capitalized)")
                                            .font(.PangramSans.bold(FHKSize.size24))
                                            .foregroundColor(FHKColor.lunarSand.opacity(0.7))
                                    }
                                                                 
                                    Spacer()
                                    LottieView(animationName: viewModel.viewState.getLottieAnimation(measureType: goal.measureType),
                                               loopMode: .playOnce,
                                               contentMode: .left)
                                    .frame(height: 150)
                                }
                                .padding(.top, -30)
                                
                                Text("Para alcanzar esta meta deberas completarla")
                                    .font(.PangramSans.bold(FHKSize.size16))
                                    .foregroundColor(FHKColor.lunarSand.opacity(0.7))
                                    .padding(.top, -30)
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
            .padding(25)
        }
    }
}

#Preview {
    let vm = GoalListScreenVM()
    
    vm.viewState.goalList = [
        GoalEntity(expirationDate: "2026-03-20 20:24:21.568999+00",
                   name: "Name",
                   emailParent: "email@gmail.com",
                   value: 200,
                   measureType: "coins",
                   status: .inCurse)
    ]
    
    return PreviewContainer {
        GoalListScreen(viewModel: vm)
    }
}
