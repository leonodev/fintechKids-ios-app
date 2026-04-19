//
//  MemberDetailScreen.swift
//  fintechKids
//
//  Created by Fredy Leon on 9/3/26.
//

import SwiftUI
import FHKCore
import FHKDesignSystem
import FHKUtils
import FHKDomain

struct MemberDetailScreen<VM: MemberDetailScreenVM>: View {
    @NavigationRouterWrapper<Routes> private var router
    @State var viewModel: VM
    let member: MemberEntity
    
    var body: some View {
        ScreenContainer(title: member.memberName.uppercased()) {
            switch viewModel.viewState.memberState {
               
            case .loading:
                loadingView
                
            case .finish, .loaded:
                loadedView
            }  
        }
        .onAppear {
            Task {
                await viewModel.action(.fetchBalance(memberId: member.id))
            }
        }
    }
    
    var loadingView: some View {
        LoadingView(msn: viewModel.viewState.msnLoading)
    }
    
    var loadedView: some View {
        ScrollView {
            LazyVStack(alignment: .center, spacing: 0) {
                
                HStack {
                    FHKCoinBadge(amount: "\(viewModel.viewState.balance?.coinsObtained ?? 0)",
                                 size: FHKSize.size16)
                    
                    FHKTimeBadge(amount: "\(viewModel.viewState.balance?.timeObtained ?? "0")",
                                 size: FHKSize.size16)
                }
                
                Spacer()
                
                FHKButtonPrimary(title: "Ver Tareas",
                                 state: .enabled,
                                 mode: .glass(.clearWithInteractive),
                                 action: {
                    router.navigate(to: .tasks(isFromChildSelection: true, member))
                })
                .padding()
            }
        }
        .refreshable {
            await viewModel.action(.fetchBalance(memberId: member.id))
        }
    }
}
