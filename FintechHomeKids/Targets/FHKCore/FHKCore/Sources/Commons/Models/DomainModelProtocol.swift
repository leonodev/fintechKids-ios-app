//
//  DomainModelProtocol.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 6/9/26.
//

import Foundation
import SwiftUI

public protocol DomainModelProtocol: Identifiable, Hashable, Equatable, Sendable {}

public protocol MappeableToDomain {
    associatedtype ModelDomain
    func toDomain() throws -> ModelDomain
}

extension Array: MappeableToDomain where Element: MappeableToDomain {
    public typealias ModelDomain = [Element.ModelDomain]
    
    public func toDomain() throws -> ModelDomain {
        try map { try $0.toDomain()}
    }
}
