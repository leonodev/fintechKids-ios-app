//
//  fintechKidsApp.swift
//  fintechKids
//
//  Created by Fredy Leon on 10/11/25.
//

import SwiftUI
import FHKCore
import FHKInjections

@main
struct fintechKidsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var appRouter = NavigationRouter<Routes>()
    private let deepLinkProcessor = DeepLinkRouter()
    @Inject(\.languageManager) private var langManager
    
    var body: some Scene {
        WindowGroup {
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
    
    private func setupNotificationService() {
        if let pushService = delegate.services.first(where: { $0 is PushNotificationService }) as? PushNotificationService {
            // We passed the PROCESSOR to the notifications service
            pushService.updateRouter(deepLinkProcessor)
        }
    }
}
