//
//  HeaderBannerView.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 8/10/26.
//

import SwiftUI

public struct HeaderBannerView<Content: View>: View {
    let content: Content
    var imagenBanner: Image
    var curveHeight: CGFloat
    
    public init(
        imagenBanner: Image = Image.headerDetail,
        curveHeight: CGFloat = FHKSize.size28,
        @ViewBuilder content: () -> Content
    ) {
        self.imagenBanner = imagenBanner
        self.curveHeight = curveHeight
        self.content = content()
    }
    
    public var body: some View {
        VStack(spacing: FHKSize.size12) {
            content
        }
        .padding(.horizontal, FHKSpace.space20)
        .padding(.top, FHKSpace.space60)
        .padding(.bottom, curveHeight)
        .frame(maxWidth: .infinity)
        .background(
            GeometryReader { proxy in
                self.imagenBanner
                    .resizable()
                    .scaledToFill()
                    .frame(width: proxy.size.width,
                           height: proxy.size.height,
                           alignment: .top)
                    .clipped()
            }
        )
        .clipShape(CurvedBannerShape(curveHeight: curveHeight))
        .ignoresSafeArea(edges: .top)
    }
}

// Para ver unicamente la pantalla
#Preview("Design / Isolated UI") {
    FHKPreview {
        HeaderBannerView {
            
        }
        .withPreviewRouter()
    }
}

