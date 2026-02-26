//
//  HomeScreen.swift
//  fintechKids
//
//  Created by Fredy Leon on 17/1/26.
//

import SwiftUI
import FHKCore
import FHKInjections
import FHKDesignSystem
import FHKDomain

struct HomeScreen<VM: HomeScreenVM>: View {
    @NavigationRouterWrapper<Routes> private var router
    @State var viewModel: VM
    
    // Properties injected
    private var toastManager: any FHKToastManagerProtocol {
        inject.toastManager
    }
    
    private var camaraPermissionManager: any FHKPermissionProtocol {
        inject.camaraPermissionManager
    }
    
    @State private var showPermissions = false
    
    var body: some View {
        ScreenContainer(title: Routes.home.title) {
              
            VStack {
                
                HStack(spacing: FHKSpace.space08) {
                    VStack(alignment: .leading) {
                        Text("Metas asignadas a:")
                            .foregroundStyle(Color.white)
                            
                        StarCoinView(text: "StarCoins", balance: "1,250")
                        
                        familyMembersList
                    }
                    .padding(.leading, 20)
                    
                    Spacer()
                }
    
//                BasicCardView { _ in
//                    print("Navegando al perfil del usuario: ")
//                } content: {
//                    VStack(alignment: .leading, spacing: 15) {
//                        // Título de la tarjeta
//                        Text("Título de la Card")
//                            .font(.headline)
//                            .foregroundColor(.white)
//                        
//                        // Descripción o cuerpo
//                        Text("Este es un ejemplo de una tarjeta básica en SwiftUI con el fondo degradado que pediste.")
//                            .font(.subheadline)
//                            .foregroundColor(.white.opacity(0.8))
//                    }
//                }
//                .padding()
                Spacer()
                
                FloatMenu(options: viewModel.model.options, callback: { index in
                    switch index {
                    case 0:
                        router.navigate(to: .members)
                        
                    default:
                        break
                    }
                    print(index)
                })
            }
            .onAppear {
                Task {
                    await viewModel.action(.fetchMemberFamily)
                }
                
//                if camaraPermissionManager.status != .authorized {
//                    showPermissions = true
//                }
            }
            .fullScreenCover(isPresented: $showPermissions) {
                PermissionRequestView(provider: camaraPermissionManager)
            }
        }
        .background(FHKColor.indigo)
    }
    
    var familyMembersList: some View {
        ScrollView {
            LazyHStack(spacing: 10) {
                
                ForEach(viewModel.model.familyMembers) { member in
                    FHKMemberItem(member: member,
                                  action: { member in
                        
                    })
                }
            }
            .padding(.top)
        }
    }
}

#Preview {
    VStack {
        HomeScreen(viewModel: HomeScreenVM())
    }
    .background(FHKColor.indigo)
}

struct BasicCardView<Content: View, T>: View {
    let content: Content
    let data: T?
    let action: (T?) -> Void

    init(data: T,
         action: @escaping (T?) -> Void,
         @ViewBuilder content: () -> Content
    ) {
        self.data = data
        self.action = action
        self.content = content()
    }

    init(action: @escaping (T?) -> Void,
         @ViewBuilder content: () -> Content
    ) where T == Any {
        self.data = nil
        self.action = action
        self.content = content()
    }

    var body: some View {
        VStack {
            content
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            FHKColor.lunarSand.opacity(0.08)
        )
        .cornerRadius(20)
        .onTapGesture {
            action(data)
        }
    }
}
