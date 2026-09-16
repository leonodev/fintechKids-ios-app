
import SwiftUI
import FLibInjections
import FHKAuth
import FHKCore
import FHKDesignSystem

@main
struct FHKMembersExampleApp: App {
    
    var api: FHKEnvironment {
        inject.fhkEnvironment
    }

    var body: some Scene {
        WindowGroup {

            VStack(spacing: 20) {
                Image(systemName: "flag.pattern.checkered")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                Text("¡Bienvenido a Members!")
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
