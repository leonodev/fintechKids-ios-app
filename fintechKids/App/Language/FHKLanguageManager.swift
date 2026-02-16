//
//  LanguageManager.swift
//  fintechKids
//
//  Created by Fredy Leon on 29/12/25.
//

import SwiftUI
import Observation
import FHKUtils
import FHKConfig
import FHKInjections

public protocol FHKLanguageManagerProtocol: FHKInjectableProtocol {
    var selectedLanguage: String { get set }
}

@Observable
@MainActor
public final class FHKLanguageManager: FHKLanguageManagerProtocol {
    public var selectedLanguage: String = Configuration.LanguageType.es.code()
}
