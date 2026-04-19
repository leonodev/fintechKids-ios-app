//
//  TaskStartScreenVM.swift
//  fintechKids
//
//  Created by Fredy Leon on 21/3/26.
//

import Foundation
import Observation
import FHKCore
import FHKInjections
import FHKDomain
import FHKFirebase
import FHKUtils

@Observable
final class TaskStartScreenVM: FHKCore.ViewModel {
    var viewState: TaskStartViewState = .init()
    
    public var fhkModal: any FHKModalProtocol {
        inject.fhkModal
    }
    
    public var fhkToast: any FHKToastProtocol {
        inject.fhkToast
    }
    
    public enum Action: Equatable {
        case startTask
        case stopTask
    }
    
    @MainActor
    public func action(_ action: Action) async {
        switch action {
            
        case .startTask:
            break
            
        case .stopTask:
            break
        }
    }
    
    func displayNotification(message: String, type: ToastType = .warning) {
        fhkToast.show(info: viewState.toastInfo(msn: message, type: type))
    }
}
