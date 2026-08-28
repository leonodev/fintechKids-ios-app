//
//  RouterWrapper.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 28/8/26.
//

import SwiftUI

@propertyWrapper
public struct Router<Destination: NavigationDestination>: DynamicProperty {
    @Environment(NavigationRouter<Destination>.self) private var router: NavigationRouter<Destination>

    public init() {}

    public var wrappedValue: NavigationRouter<Destination> {
        router
    }
}
