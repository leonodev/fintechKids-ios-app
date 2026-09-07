//
//  FHKPreview.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 25/8/26.
//

import SwiftUI

public struct FHKPreview<Content: View>: View {
    private let content: () -> Content
    
    public init(
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content
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
