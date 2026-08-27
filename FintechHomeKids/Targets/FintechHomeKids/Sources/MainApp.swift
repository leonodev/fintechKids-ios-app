
import SwiftUI
import FHKAuth
import FHKCore
import FHKDesignSystem

@main
struct MainApp: App {
    @UIApplicationDelegateAdaptor(FHKAppDelegate.self) var delegate
    private let jailbreak: JailbreakManager = .live
    
    @State private var authRouter = NavigationRouter<AuthRoute>()
    private let deepLinkRouter = FHKDeepLinkRouter()
    
    init() {
        setupDeepLinks()
    }
    
    var body: some Scene {
        WindowGroup {
            FHKSplashScreen()
        }
    }
    
    //Registro de Handlers concretos
    private func setupDeepLinks() {
        deepLinkRouter.register(handler: AuthDeepLinkHandler(router: authRouter))
    }
    
    /// Vista de arranque según el estado de sesión
        @ViewBuilder
    var startAppView: some View {
        Group {
            if inject.fhkSession.isAuthenticated() {
                authenticatedFlow
            } else {
                unauthenticatedFlow
            }
        }
        .task {
            await inject.fhkSession.initializeSession()
        }
        .onAppear {
            // Pasa el router del flujo activo o maneja el deeplink según corresponda
            setupNotificationService()
        }
        .onOpenURL { url in
            deepLinkRouter.handle(url: url)
        }
        .modifier(ModalPresenter(manager: inject.fhkModal))
    }
    
    // MARK: - Flujo No Autenticado (Login, Registro, Splash)
    var unauthenticatedFlow: some View {
        NavigationContainer(router: authRouter) {
            // Pantalla inicial del flujo de Auth
            FHKSplashScreen()
            // Conectas las rutas exclusivas de FHKAuth
                .navigationDestination(for: AuthRoute.self) { route in
                    switch route {
                    case .login:
                        EmptyView()
                        //@comentado
                        //FHKLoginScreen(viewModel: FHKLoginScreenVM())
                    case .register:
                        EmptyView()
                        
                    case .language:
                        EmptyView()
                        //@comentado
                        //FHKRegisterScreen(viewModel: FHKRegisterScreenVM())
                        // case .forgotPassword, etc.
                    }
                }
        }
    }
    
    // MARK: - Flujo Autenticado (Home, Perfil, Tareas)
    var authenticatedFlow: some View {
        EmptyView()
        //@comentado
        //        NavigationContainer(router: homeRouter) {
        //            // Pantalla inicial del flujo autenticado
        //            FHKHomeScreen(viewModel: FHKHomeScreenVM())
        //                // Conectas las rutas del módulo Home/Main
        //                .navigationDestination(for: HomeRoute.self) { route in
        //                    switch route {
        //                    case .profile:
        //                        FHKProfileScreen(viewModel: FHKProfileScreenVM())
        //                    case .members:
        //                        FHKRegisterMembersScreen(viewModel: FHKRegisterMembersScreenVM())
        //                    case .memberDetail(let member):
        //                        FHKMemberDetailScreen(viewModel: FHKMemberDetailScreenVM(), member: member)
        //                    }
        //                }
        //        }
    }
    
    
    private func setupNotificationService() {
        //@comentado
//        if let pushService = delegate.services.first(where: {
//            $0 is PushNotificationService }) as? PushNotificationService {
//            pushService.updateRouter(deepLinkRouter)
//        }
    }
}
