//
//  Localization+Tasks.swift
//  FHKTasks
//
//  Created by Fredy Leon on 27/9/26.
//

import Foundation
import FHKDesignSystem

extension String {
    /// Resuelve la clave usando implícitamente el Bundle de ESTE módulo
    @MainActor
    var localized: String {
        self.localized(.module)
    }
}
