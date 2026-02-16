//
//  ProfileScreenVM.swift
//  fintechKids
//
//  Created by Fredy Leon on 16/2/26.
//

class ProfileScreenVM  {
    
   
   /*
    En tu StorageManager
    Añade esta función para eliminar cualquier rastro de una llave específica.
    
    
    public func deleteKeychain(for key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status == errSecSuccess {
            print("Successfully deleted key: \(key)")
        } else if status != errSecItemNotFound {
            print("Error deleting key from Keychain: \(status)")
        }
    }
    */
    
    
    
    /*
     
     En tu Actor Login
     El actor debe ser el responsable de limpiar el estado de autenticación tanto en el servidor (Supabase) como en el almacenamiento local.
     
     
     
     public func logoutUser() async throws {
         // 1. Cerramos sesión en Supabase (invalida el token en el servidor)
         let service = try factory.makeAuthService(for: .supabase)
         try await service.logoutUser()
         
         // 2. Limpiamos nuestro estado interno
         self.isAuthenticated = false
         
         // Nota: El borrado del Keychain lo haremos desde el ViewModel
         // o inyectando el storageManager aquí si prefieres.
     }
     */
    
    /*
     
     Desde este VM
     
     @MainActor
     func logout() async {
         do {
             // 1. Llamamos al actor para cerrar sesión en el servidor
             try await loginActor.logoutUser()
             
             // 2. Borramos el token del Keychain
             // Esto hace que 'hasSavedAuthToken' devuelva false inmediatamente
             storageManager.deleteKeychain(for: KeychainKey.authToken.rawValue)
             
             // 3. Opcional: ¿Borramos la semilla (securitySeed)?
             // Normalmente NO se borra, para que el usuario pueda volver a
             // loguearse manualmente en este dispositivo sin problemas.
             
             model.loginState = .initial // Volvemos al estado inicial de la UI
             
         } catch {
             print("Error durante el logout: \(error)")
         }
     }
     
     
     
     
     
     
     Resumen del ciclo de vida del Token
     Registro: Creas la securitySeed (se queda para siempre en el dispositivo).

     Login Manual: Generas el Hash → Obtienes Token → Lo guardas con FaceID.

     App Cerrada/Abierta: hasSavedAuthToken es true → loginWithBiometrics → Entras.

     Logout: Llamas a deleteKeychain → hasSavedAuthToken es ahora false. El FaceID no volverá a saltar solo.

     ¿Por qué es importante el borrado?
     Si solo haces logout en Supabase pero dejas el token en el Keychain:

     Tu UI creerá que hay una sesión lista (hasSavedAuthToken == true).

     Saltará el FaceID.

     Recuperarás un token que el servidor ya rechazó.

     Resultado: Una mala experiencia de usuario (un bucle de errores).

     ¿Ya tienes implementada la pantalla de ajustes o el botón donde el usuario haría este Logout? Si quieres, podemos revisar cómo manejar la navegación para que, tras el borrado, el usuario sea expulsado automáticamente a la pantalla de bienvenida.
     */
}
