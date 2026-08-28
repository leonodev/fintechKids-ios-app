
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
    
    private var fhkToast: FHKToast {
        inject.fhkToast
    }
    
    init() {
        setupDeepLinks()
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                Group {
                    if jailbreak.isDeviceCompromised() { 
                        blockerAppView
                    } else {
                        startAppView
                    }
                }
                .animation(.default, value: jailbreak.isDeviceCompromised())
                
                infoAppView
            }
            .task {
                await inject.fhkStorage.clearKeychainIfNewInstallation()
            }
        }
    }
    
    //Registro de Handlers concretos
    private func setupDeepLinks() {
        deepLinkRouter.register(handler: AuthDeepLinkHandler(router: authRouter))
    }
    
    // MARK: - Componentes auxiliares (Security / Toast)
    var blockerAppView: some View {
        SecurityBlockerView(
            title: "title_screen_security".localized(.module),
            msn: "msn_screen_security".localized(.module),
            titleBtn: "title_btn_screen_security".localized(.module)
        )
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
    
    // MARK: - Flujo No Autenticado (Splash, Language, Login, Registro)
    var unauthenticatedFlow: some View {
        NavigationContainer(router: authRouter) {
            FHKSplashScreen()
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
    
    var infoAppView: some View {
        VStack {
            if inject.fhkToast.isVisible(), let info = inject.fhkToast.currentToast() {
                ToastView(
                    isVisible: Binding(
                        get: { inject.fhkToast.isVisible() },
                        set: { _ in inject.fhkToast.dismiss() }
                    ),
                    info: info
                )
                .transition(.move(edge: .top).combined(with: .opacity))
            }
            Spacer()
        }
        .padding(.top, 10)
        .zIndex(999)
    }
    
    
    private func setupNotificationService() {
        //@comentado
//        if let pushService = delegate.services.first(where: {
//            $0 is PushNotificationService }) as? PushNotificationService {
//            pushService.updateRouter(deepLinkRouter)
//        }
    }
}
