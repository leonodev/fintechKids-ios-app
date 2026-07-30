//
//  FintechKidsApp.swift
//  fintechKids
//
//  Created by Fredy Leon on 10/11/25.
//

import SwiftUI
import FHKCore
import FHKInjections
import FHKDesignSystem
import FHKDomain
import FHKStorage

@main
struct FintechKidsApp: App {
    @UIApplicationDelegateAdaptor(FHKAppDelegate.self) var delegate
    @StateObject private var appState = FHKAppState()
    @State private var appRouter = NavigationRouter<FHKRoutes>()
    private let deepLinkProcessor: FHKDeepLinkRouterProtocol = FHKDeepLinkRouter()
    
    private var fhkToast: FHKToast {
        inject.fhkToast
    }
    
    private var fhkModal: FHKModal {
        inject.fhkModal
    }
    
    private var fhkStorage: FHKStorageManager {
        inject.fhkStorage
    }
    
    private var fhkSessionManager: FHKSession {
        inject.fhkSession
    }
    
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
                            if fhkSessionManager.isAuthenticated() {
                                FHKHomeScreen(viewModel: FHKHomeScreenVM())
                            } else {
                                FHKSplashScreen(viewModel: FHKSplashScreenVM())
                            }
                        }
                        .task {
                            await fhkSessionManager.initializeSession()
                        }
                        .onAppear {
                            deepLinkProcessor.setAppRouter(appRouter)
                            setupNotificationService()
                        }
                        .onOpenURL { url in
                            deepLinkProcessor.handle(url: url)
                        }
                        .modifier(FHKModalPresenter(manager: fhkModal)) // draw overlay by modal blur
                    }
                }
                .animation(.default, value: appState.isJailbroken)
                
                VStack {
                    if fhkToast.isVisible(), let info = fhkToast.currentToast() {
                        ToastView(
                            isVisible: Binding(
                                get: { fhkToast.isVisible() },
                                set: { _ in fhkToast.dismiss() }
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
            .task {
                await fhkStorage.clearKeychainIfNewInstallation()
            }
        }
    }
    
    private func setupNotificationService() {
        if let pushService = delegate.services.first(where: {
            $0 is FHKPushNotificationService }) as? FHKPushNotificationService {
            // We passed the PROCESSOR to the notifications service
            pushService.updateRouter(deepLinkProcessor)
        }
    }
}
