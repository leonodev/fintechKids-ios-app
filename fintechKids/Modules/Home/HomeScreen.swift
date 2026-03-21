//
//  HomeScreen.swift
//  fintechKids
//
//  Created by Fredy Leon on 17/1/26.
//

import SwiftUI
import FHKCore
import FHKDesignSystem

struct HomeScreen<VM: HomeScreenVM>: View {
    @NavigationRouterWrapper<Routes> private var router
    @State var viewModel: VM
    @State private var showPermissions = false
    
    var body: some View {
        ScreenContainer(title: Routes.home.title) {
            
            switch viewModel.viewState.homeState {
                
            case .loaded:
                loadedView
            }
        }
        .background(FHKColor.indigo)
        .onAppear {
            Task {
                await viewModel.action(.fetchMemberFamily)
            }
            
            //                if camaraPermissionManager.status != .authorized {
            //                    showPermissions = true
            //                }
        }
    }

    var loadedView: some View {
        VStack {
            headerView
            
            membersView
            
            Spacer()
            
            cardViewExampleView
            
            floatMenuView
        }
        .fullScreenCover(isPresented: $showPermissions) {
            PermissionRequestView(provider: viewModel.fhkCameraPermission)
        }
    }
    
    var headerView: some View {
        HStack {
            Text(viewModel.viewState.titleMemberFamily)
                .foregroundStyle(Color.white)
            
            Spacer()
            
            AvatarView(name: viewModel.parentMail ?? "--", size: FHKSize.size52)
                .onTapGesture {
                    router.navigate(to: .profile)
                }
        }
        .padding(.horizontal)
    }
    
    var membersView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: FHKSpace.space16) {
                if viewModel.familyMembers.isEmpty {
                    FHKMemberItem.skeletons(count: 3)
                } else {
                    ForEach(viewModel.familyMembers) { member in
                        FHKMemberItem(id: viewModel.getId(member: member),
                                      avatarName: viewModel.getAvatarMember(member: member),
                                      nameMember: viewModel.getNameMember(member: member),
                                      nameMemberError: viewModel.viewState.errorNameMember,
                                      state: viewModel.viewState.getStateItemMemberComponent(
                                        memberName: viewModel.getNameMember(member: member),
                                        avatarName: viewModel.getAvatarMember(member: member)
                                      ),
                                      action: { uuid in
                            router.navigate(to: .memberDetail(member))
                        })
                    }
                }
            }
            .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
    }
    
    var cardViewExampleView: some View {
        FHKCardView { _ in
            print("Navegando al perfil del usuario: ")
        } content: {
            VStack(alignment: .leading, spacing: 15) {
                // Título de la tarjeta
                Text("Título de la Card")
                    .font(.headline)
                    .foregroundColor(.white)
                
                // Descripción o cuerpo
                Text("Este es un ejemplo de una tarjeta básica en SwiftUI con el fondo degradado que pediste.")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .padding()
    }
    
    var floatMenuView: some View {
        FloatMenu(options: viewModel.viewState.options,
                  callback: { menu in
            switch menu {
            case .members:
                router.navigate(to: .members)
                
            case .tasks:
                router.navigate(to: .tasks)
                
            case .goals:
                router.navigate(to: .goals)
                
            default:
                break
            }
            print(index)
        })
    }
}

#Preview {
    VStack {
        HomeScreen(viewModel: HomeScreenVM())
    }
    .background(FHKColor.indigo)
}

extension FHKMemberItem {
    /// Genera una vista con el número de esqueletos deseado.
    @ViewBuilder
    public static func skeletons(count: Int = 3) -> some View {
        // Usamos un HStack o el contenedor que suelas usar en tu UI
        HStack(spacing: FHKSpace.space16) {
            ForEach(0..<count, id: \.self) { _ in
                FHKMemberItem(
                    state: .skeleton,
                    action: { _ in }
                )
            }
        }
    }
}
