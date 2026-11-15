//
//  ScreenContainer.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 27/8/26.
//

//
//  ScreenContainer.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 27/8/26.
//

import SwiftUI

public struct FHKScreenContainer<HeaderContent: View, Content: View>: View {
    private let headerContent: HeaderContent?
    private let content: () -> Content
    private let showNavigationBar: Bool
    private let backgroundImage: Image?
    
    ///Safe Area/Notch superior + Padding Top  of HeaderBannerView + curveHeight of HeaderBannerView)
    private let headerTotalHeight: CGFloat = FHKSpace.space148
    
    public init(
        showNavigationBar: Bool = true,
        backgroundImage: Image? = nil,
        @ViewBuilder headerContent: () -> HeaderContent,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.headerContent = headerContent()
        self.showNavigationBar = showNavigationBar
        self.backgroundImage = backgroundImage
        self.content = content
    }

    public var body: some View {
        ZStack(alignment: .top) {
            ZStack {
 
                if let backgroundImage = backgroundImage {
                    backgroundImage
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                        .ignoresSafeArea()
                }
               
                VStack {
                    content()
                    Spacer()
                }
                .padding(.top, headerTotalHeight)
                .background(FHKColor.basicWhite)
                .zIndex(1)
            }
            .ignoresSafeArea()

            if let headerContent = headerContent {
                ZStack {
                    VStack(spacing: 0) {
                        HeaderBannerView {
                            headerContent
                        }
                        Spacer()
                    }
                    .zIndex(0)
                    .ignoresSafeArea(edges: .top)
                }
            }
        }
        .navigationBarHidden(!showNavigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.light, for: .navigationBar)
        .toolbarBackground(Color.clear, for: .navigationBar)
        .toolbar(.visible, for: .navigationBar)
    }
}

// Para ver únicamente la pantalla
#Preview("Design / Isolated UI") {
    FHKPreview {
        FHKScreenContainer(
            headerContent: {
                VStack(spacing: 4) {
                    Text("Mi Título Personalizado")
                        .font(.headline)
                        .foregroundColor(FHKColor.indigo)
                    Text("Subtítulo extra o componente custom")
                        .font(.subheadline)
                        .foregroundColor(FHKColor.indigo.opacity(0.5))
                }
            },
            content: {
                Text("Contenido de la pantalla aquí")
            }
        )
        .withPreviewRouter()
    }
}
