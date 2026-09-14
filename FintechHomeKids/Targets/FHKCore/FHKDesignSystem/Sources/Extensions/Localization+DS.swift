//
//  Localization+DS.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 13/9/26.
//

import Foundation

extension String {
    /// Resuelve la clave usando implícitamente el Bundle de ESTE módulo
    @MainActor
    var localized: String {
        self.localized(.module)
    }
}
