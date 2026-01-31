//
//  FHKContainer.swift
//  fintechKids
//
//  Created by Fredy Leon on 29/12/25.
//
import SwiftUI
import FHKInjections
import FHKDesignSystem

public struct ScreenContainer<Content: View>: View {
    @Inject(\.languageManager) private var langManager
    
    private let content: Content
    private let showNavigationBar: Bool
    private let title: String?

    public init(
        title: String? = nil,
        showNavigationBar: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.showNavigationBar = showNavigationBar
        self.content = content()
    }
    
    public var body: some View {
        ZStack {
            LinearGradient(
                stops: [
                    .init(color: FHKColor.indigo, location: 0.1),
                    .init(color: .indigo, location: 0.9)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea() 
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
                .observeLanguage()
            // add here others global features
            // .onTapGesture { hideKeyboard() }
            // .trackScreenView("NombreDeLaPantalla")
        }
        .navigationBarHidden(!showNavigationBar)
        .navigationTitle(title ?? "")
        .navigationBarTitleDisplayMode(.inline) // O el que prefieras
    }
}
