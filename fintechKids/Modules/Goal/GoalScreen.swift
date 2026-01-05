//
//  GoalScreen.swift
//  fintechKids
//
//  Created by Fredy Leon on 1/1/26.
//

import SwiftUI

struct GoalScreen: View {
    var id: String
    
    var body: some View {
        Text("Hello, Goals ID! \(id)")
    }
}

#Preview {
    GoalScreen(id: "123")
}
