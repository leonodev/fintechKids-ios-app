//
//  FHKCore.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 27/8/26.
//

public enum FHKCore {}


public extension FHKCore {
    @MainActor
    protocol ViewModel {
        associatedtype Action: Equatable
        func action(_ action: Action) async
    }
}
public extension FHKCore.ViewModel {
    var nameAction: String {
        String(describing: Self.self) + ".Action"
    }
}
