//
//  ToastService.swift
//  fintechKids
//
//  Created by Fredy Leon on 18/1/26.
//

import SwiftUI
import Combine
import FHKCore
import FHKDesignSystem

/// Protocolo definido para la inyección de dependencias
public protocol ToastServiceProtocol: Sendable {
    var currentToast: ToastInfo? { get set }
    var isVisible: Bool { get set }
    @MainActor func show(info: ToastInfo, duration: Double)
    @MainActor func dismiss()
}

@MainActor
@Observable
final class ToastService: NSObject, ApplicationService, ToastServiceProtocol {
    
    // El estado es privado para asegurar que solo se modifique vía métodos controlados
    var currentToast: ToastInfo?
    var isVisible: Bool = false
    
    // Guardamos la referencia de la tarea para poder cancelarla si llega un nuevo Toast
    private var dismissalTask: Task<Void, Never>?

    // MARK: - ToastServiceProtocol
    
    /// Muestra un toast con una configuración y duración específica
    func show(info: ToastInfo, duration: Double = 5.0) {
        // 1. Cancelamos cualquier tarea de ocultado pendiente
        dismissalTask?.cancel()
        
        // 2. Actualizamos el contenido
        self.currentToast = info
        
        // 3. Animamos la aparición
        withAnimation(.snappy) {
            self.isVisible = true
        }
        
        // 4. Creamos una nueva tarea asíncrona para el auto-ocultado (Swift 6 Way)
        dismissalTask = Task {
            // Convertimos segundos a nanosegundos para ContinuousClock (iOS 16+)
            try? await Task.sleep(for: .seconds(duration))
            
            // Verificamos si la tarea no ha sido cancelada antes de ocultar
            if !Task.isCancelled {
                self.dismiss()
            }
        }
    }
    
    /// Oculta el toast inmediatamente
    func dismiss() {
        dismissalTask?.cancel()
        dismissalTask = nil
        
        withAnimation(.snappy) {
            self.isVisible = false
        }
    }
}
