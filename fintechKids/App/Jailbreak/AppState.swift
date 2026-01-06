//
//  AppState.swift
//  fintechKids
//
//  Created by Fredy Leon on 5/1/26.
//

import SwiftUI
import Combine
import FHKAuth

class AppState: ObservableObject {
    @Published var isJailbroken: Bool = false
    
    // Definimos una propiedad para guardar el detector
    private let detector: JailbreakManagerProtocol

    // Usamos 'SecurityManager.shared' como valor por defecto
    init(detector: JailbreakManagerProtocol = SecurityManager.shared) {
        self.detector = detector
        
        // Ejecutamos la comprobación al iniciar
        self.checkSecurity()
    }
    
    func checkSecurity() {
        // Ahora usamos el detector inyectado
        self.isJailbroken = detector.isDeviceCompromised
    }
}
