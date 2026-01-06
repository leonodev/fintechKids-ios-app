//
//  GoalScreen.swift
//  fintechKids
//
//  Created by Fredy Leon on 1/1/26.
//

import SwiftUI
import FHKUtils

struct GoalScreen: View {
    var id: String
    
    var body: some View {
        ScreenContainer {
            Text("goal".localized().capitalizingFirstLetter() + " \(id)")
        }
    }
}

#Preview {
    GoalScreen(id: "123")
}
