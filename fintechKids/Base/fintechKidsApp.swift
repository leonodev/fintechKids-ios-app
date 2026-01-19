//
//  fintechKidsApp.swift
//  fintechKids
//
//  Created by Fredy Leon on 10/11/25.
//

import SwiftUI
import FHKCore
import FHKInjections
import FHKDesignSystem

@main
struct FintechKidsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var appState = AppState()
    @State private var appRouter = NavigationRouter<Routes>()
    private let deepLinkProcessor: DeepLinkRouterProtocol = DeepLinkRouter()
    
    @Inject(\.toastService) var toastService: ToastServiceProtocol
    @Inject(\.languageManager) private var langManager
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                Group {
                    if appState.isJailbroken {
                        SecurityBlockerView(
                            title: "title_screen_security".localized(),
                            msn: "msn_screen_security".localized(),
                            titleBtn: "title_btn_screen_security".localized())
                    } else {
                        NavigationContainer(router: appRouter) {
                            SplashScreen()
                        }
                        .onAppear {
                            Task { await langManager.readLanguage() }
                            deepLinkProcessor.setAppRouter(appRouter)
                            setupNotificationService()
                        }
                        .onOpenURL { url in
                            deepLinkProcessor.handle(url: url)
                        }
                    }
                }
                .animation(.default, value: appState.isJailbroken)
                
                VStack {
                    if toastService.isVisible, let info = toastService.currentToast {
                        ToastView(
                            isVisible: Binding(
                                get: { toastService.isVisible },
                                set: { _ in toastService.dismiss() }
                            ),
                            info: info
                        )
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    Spacer() // Empuja el Toast al techo
                }
                .padding(.top, 10) // Ajuste fino para la safe area si es necesario
                .zIndex(999) // Prioridad de renderizado absoluta
            }
        }
    }
    
    private func setupNotificationService() {
        if let pushService = delegate.services.first(where: {
            $0 is PushNotificationService }) as? PushNotificationService {
            // We passed the PROCESSOR to the notifications service
            pushService.updateRouter(deepLinkProcessor)
        }
    }
}
