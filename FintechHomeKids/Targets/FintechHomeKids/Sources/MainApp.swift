
import SwiftUI
import FHKAuth

@main
struct MainApp: App {
    @UIApplicationDelegateAdaptor(FHKAppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            FHKSplashScreen()
        }
    }
}
