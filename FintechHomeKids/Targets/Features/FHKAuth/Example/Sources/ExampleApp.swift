
import SwiftUI
import FLibInjections
import FHKAuth
import FHKCore
import FHKDesignSystem
import FHKTesting

@main
struct FHKAuthExampleApp: App {
    
    init() {
        // Inicializa todos los mocks y dependencias por defecto al arrancar la feature
        FHKPreviewDependencies.registerDefaults()
    }
    
    var api: FHKEnvironment {
        inject.fhkEnvironment
    }

    var body: some Scene {
        WindowGroup {

            VStack(spacing: 20) {
                Image(systemName: "flag.pattern.checkered")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                Text("¡Bienvenido a Authentication!")
                    .font(.title)
                    .bold()
                Text("Esta vista corre aislada en su propia Micro-App 🚀")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("Enviroment:")
                        .font(.body)
                        .bold()
                    
                    Text("\(String(describing: api.baseURL()))")
                        .font(.headline)
                        .foregroundStyle(FHKColor.wine)
                        .bold()
                }
            }
            .padding()
        }
    }
}
