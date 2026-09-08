//
//  FHKHomeScreen.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 8/9/26.
//

import SwiftUI
import FHKDesignSystem
import FLibUtils
import FHKCore

public struct FHKHomeScreen: View {
    @State private var viewModel: FHKHomeScreenVM
    @Router private var router: NavigationRouter<RoutesDestination>
    
    public init() {
        self._viewModel = State(initialValue: FHKHomeScreenVM())
    }
    
    public var body: some View {
        
        FHKScreenContainer {
            
        }
        
    }
}

// Para ver unicamente la pantalla
#Preview("Design / Isolated UI") {
    FHKPreview {
        FHKHomeScreen()
            .withPreviewRouter()
    }
}

