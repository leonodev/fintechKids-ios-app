//
//  HomeDI.swift
//  fintechKids
//
//  Created by Fredy Leon on 17/1/26.
//

import Foundation
import FHKInjections
import FHKDesignSystem

public extension DependenciesInjection {
    
    var camaraPermission: any PermissionProtocol {
        get { self[(any PermissionProtocol).self] }
        set { self[(any PermissionProtocol).self] = newValue }
    }
}
