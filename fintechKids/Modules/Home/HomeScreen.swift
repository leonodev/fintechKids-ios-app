//
//  HomeScreen.swift
//  fintechKids
//
//  Created by Fredy Leon on 17/1/26.
//

import SwiftUI
import FHKInjections
import FHKDesignSystem

struct HomeScreen: View {
    @Inject(\.camaraPermission) var camaraPermission: PermissionProtocol
    
    @State private var showPermissions = false
    
    var body: some View {
        VStack {
            Text("Bienvenido a FintechKids")
            
            
        }
        .onAppear {
            if camaraPermission.status != .authorized {
                showPermissions = true
            }
        }
        .fullScreenCover(isPresented: $showPermissions) {
            PermissionRequestView(provider: camaraPermission)
        }
    }
}

#Preview {
    HomeScreen()
}
