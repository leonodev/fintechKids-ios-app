//
//  ContentView.swift
//  fintechKids
//
//  Created by Fredy Leon on 10/11/25.
//

import SwiftUI
import FHKUtils
import FHKCore
import FHKAuth
import FHKDesignSystem

struct ContentView: View {
    var environment: String {
        #if DEBUG
        return "🚀 DESARROLLO - ATS Deshabilitado"
        #else
        
        return "📱 DESARROLLO - ATS HABILITADO"
        #endif
    }
    
    var body: some View {
        VStack {
            EnvironmentView()
        }
        .onAppear  {
            Logger.info("Success")
        }
        
    }
}


#Preview {
    ContentView()
}
