//
//  HomeViewState.swift
//  fintechKids
//
//  Created by Fredy Leon on 21/1/26.
//

import SwiftUI
import Observation
import FHKCore
import FHKDesignSystem

@Observable
public class HomeViewState {
    var options: [FloatMenu.Option]
    
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
}
