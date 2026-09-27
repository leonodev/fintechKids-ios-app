//
//  RoutingErrorView.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 27/9/26.
//

import SwiftUI

public struct FHKRoutingErrorView: View {
    
    var title: String {
        "title_error_routing".localized
    }
    
    var message: String {
        "mss_error_routing".localized
    }
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundColor(.orange)
                .padding()
            
            Text(title)
                .font(.headline)
                .foregroundColor(FHKColor.lunarSand)
            
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(FHKColor.yellow)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

// Para ver unicamente la pantalla
#Preview("Design / Isolated UI") {
    FHKPreview {
        FHKRoutingErrorView()
            .withPreviewRouter()
    }
}

