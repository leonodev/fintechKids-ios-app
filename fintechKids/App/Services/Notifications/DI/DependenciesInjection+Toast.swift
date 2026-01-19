//
//  DependenciesInjection+Toast.swift
//  fintechKids
//
//  Created by Fredy Leon on 18/1/26.
//

import FHKInjections

public extension DependenciesInjection {
    var toastService: any ToastServiceProtocol {
        get { self[(any ToastServiceProtocol).self] }
        set { self[(any ToastServiceProtocol).self] = newValue }
    }
}
