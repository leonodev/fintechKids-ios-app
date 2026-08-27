//
//  DescriptionCardView.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 13/3/26.
//

import SwiftUI

public struct FHKDescriptionCardView: View {
    let title: String
    let description: String
    let isEnable: Bool
    
    public init(title: String, description: String, isEnable: Bool = true) {
        self.title = title
        self.description = description
        self.isEnable = isEnable
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(.PangramSans.bold(FHKSize.size16))
                .foregroundColor(isEnable
                                 ? FHKColor.pastelPink.opacity(0.8)
                                 : FHKColor.gray.opacity(0.5)
                )
            
            if !description.isEmpty {
                Text(description)
                    .font(.PangramSans.bold(FHKSize.size12))
                    .foregroundColor(isEnable
                                     ? FHKColor.basicWhite.opacity(0.8)
                                     : FHKColor.gray.opacity(0.5)
                    )
            }
        }
    }
}

#Preview {
    VStack {
        VStack(spacing: 50) {
            FHKDescriptionCardView(title: "Title enable",
                                   description: "Description enable")
            
            FHKDescriptionCardView(title: "Title disabled",
                                   description: "Description disabled",
                                   isEnable: false)
        }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(FHKColor.indigo)
}
