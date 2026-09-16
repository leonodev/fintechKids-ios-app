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
    @Router private var router: NavigationRouter<RoutesDestination>
    private var memberID: UUID
    
    public init(_ memberID: UUID) {
        self._viewModel = State(initialValue: FHKMemberDetailScreenVM())
        self.memberID = memberID
    }
    
    
    public var body: some View {
        
        FHKScreenContainer(title: viewModel.viewState.member?.memberName) {
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
                   // router.navigate(to: .tasks(isFromChildSelection: true, member))
                })
                .padding()
            }
        }
        .refreshable {
            //await viewModel.action(.fetchBalance(memberId: member.id))
        }
    }
}

// Para ver unicamente la pantalla
#Preview("Design / Isolated UI") {
    FHKPreview {
        FHKMemberDetailScreen(UUID())
            .withPreviewRouter()
    }
}
