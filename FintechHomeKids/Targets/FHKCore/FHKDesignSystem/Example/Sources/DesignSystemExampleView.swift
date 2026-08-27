//
//  DesignSystemExampleView.swift
//  FintechKidsApp
//
//  Created by fleon  on 7/8/26.
//

import SwiftUI

public struct DesignSystemExampleView: View {

    public var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Image(systemName: "gift.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            Text("¡Wellcome to DesignSystem!")
                .font(.title)
                .bold()
            Text("DesignSystem Micro-App 🚀")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    DesignSystemExampleView()
}
