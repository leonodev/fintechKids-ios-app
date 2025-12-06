//
//  LanguageView.swift
//  fintechKids
//
//  Created by Fredy Leon on 10/11/25.
//

import SwiftUI
import FHKUtils
import FHKCore
import FHKAuth
import FHKDesignSystem

struct LanguageView: View {
    @Namespace var nameSpaceMenu
    @State private var isExpanded = false
    @State private var selectedFlag: Image = .spainCircleFlag
    
    private let allFlags: [Image] = [
        .spainCircleFlag,
        .italyCircleFlag,
        .englandCircleFlag,
        .franceCircleFlag
    ]
    
    private var menuOptions: [Image] {
        // Exclude the currently selected flag from the menu
        allFlags.filter { $0 != selectedFlag }
    }
    
    private let flagAnimation = Animation.spring(response: 0.4,
                                                 dampingFraction: 0.8,
                                                 blendDuration: 0.15)
    
    var body: some View {
        ZStack(alignment: .leading) {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            EnvironmentView()
                .padding(.top, FHKSize.size08)
            
            
            VStack {
                menuLanguageView
                    .accessibilityIdentifier("menu_language")
                Spacer()
            }
        }
    }
    
    var menuLanguageView: some View {
        HStack {
            Spacer()
            
            GlassEffectContainer {
                VStack(alignment: .trailing) {
                    menuClosedView
                    if isExpanded {
                        menuOpenedView
                    }
                }
                .padding()
            }
            .padding(.top, FHKSize.size12)
            .padding(.trailing, FHKSize.size12)
        }
    }
    
    var menuClosedView: some View {
        selectedFlag
            .resizable()
            .frame(width: FHKSize.size52, height: FHKSize.size52)
            .onTapGesture {
                withAnimation(flagAnimation) {
                    isExpanded.toggle()
                }
            }
    }
    
    var menuOpenedView: some View {
        Group {
            ForEach(Array(menuOptions.enumerated()), id: \.offset) { _, img in
                img
                    .resizable()
                    .frame(width: FHKSize.size48, height: FHKSize.size48)
                    .onTapGesture {
                        withAnimation(flagAnimation) {
                            selectedFlag = img
                            isExpanded = false
                        }
                    }
            }
        }
        .transition(.asymmetric(insertion: .move(edge: .top).combined(with: .opacity),
                                 removal: .move(edge: .top).combined(with: .opacity)))
        .glassEffect()
        .glassEffectUnion(id: 1, namespace: nameSpaceMenu)
        .glassEffectTransition(.matchedGeometry)
    }
}


#Preview {
    LanguageView()
}
