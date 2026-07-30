//
//  FHKPreview.swift
//  fintechKids
//
//  Created by fleon  on 3/7/26.
//

import SwiftUI
import FHKDesignSystem

public struct FHKPreview<Content: View>: View {
    private let content: () -> Content
    
    public init(
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content
        
        #if DEBUG
        try? FHKBasicDependencies.register()
        try? FHKModulesDependencies.register()
        #endif
    }
     
    public var body: some View {
        VStack {
            Spacer()
            content()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(FHKColor.indigo)
    }
}
