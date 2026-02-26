//
//  HomeModel.swift
//  fintechKids
//
//  Created by Fredy Leon on 21/1/26.
//

import SwiftUI
import Observation
import FHKUtils
import FHKCore
import FHKDesignSystem
import FHKConfig
import FHKInjections
import FHKDomain

@Observable
public class HomeModel {
    var options: [FloatMenu.Option]
    
    // Properties Injected
    private var configManager: FHKConfigurationProtocol {
        inject.configManager
    }
    
    public var familyMembers: [FamilyMember] = []
    
    private var _homeState: FHKCore.State<Never> = .loaded
    var homeState: FHKCore.State<Never> {
        get { _homeState }
        set {_homeState = newValue}
    }

    init() {
        options = [
            .init(image: .init(systemName: "person.crop.circle.badge.plus"), color: FHKColor.ultraPurple),
            .init(image: .init(systemName: "note.text.badge.plus"), color: FHKColor.fuchsiaPink),
            .init(image: .init(systemName: "star.fill"), color: FHKColor.yellow)
        ]
    }
    
    public func getParentMail() async -> String? {
        await configManager.getParentMail()
    }
}
