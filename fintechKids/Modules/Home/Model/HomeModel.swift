//
//  HomeModel.swift
//  fintechKids
//
//  Created by Fredy Leon on 21/1/26.
//

import SwiftUI
import Combine
import Observation
import FHKAuth
import FHKUtils
import FHKCore
import FHKDesignSystem

@Observable
public class HomeModel {
    var options: [FloatMenu.Option]
    
    init() {
        options = [
            .init(image: .init(systemName: "person.crop.circle.badge.plus"), color: FHKColor.ultraPurple),
            .init(image: .init(systemName: "note.text.badge.plus"), color: FHKColor.fuchsiaPink),
            .init(image: .init(systemName: "star.fill"), color: FHKColor.yellow)
        ]
    }
}
