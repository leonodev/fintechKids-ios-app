//
//  FHKSplashScreenVM.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 25/8/26.
//

import Observation

@Observable
public final class FHKSplashScreenVM: FHKCore.ViewModel {
    var viewState: FHKSplashViewState = .init()
    
    public init() {}
    
    public enum Action: Equatable {
        case readLanguageCurrent
    }
    
    @MainActor
    public func action(_ action: Action) async {
        switch action {
            
        case .readLanguageCurrent:
            await readLanguageCurrent()
        }
    }
    
    @MainActor
    private func readLanguageCurrent() async {
       
    }
}

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
