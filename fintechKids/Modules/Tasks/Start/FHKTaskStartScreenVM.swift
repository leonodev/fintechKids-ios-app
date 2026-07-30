//
//  FHKTaskStartScreenVM.swift
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
final class FHKTaskStartScreenVM: FHKCore.ViewModel {
    var viewState: FHKTaskStartViewState = .init()
    
    public var fhkModal: FHKModal {
        inject.fhkModal
    }
    
    public var fhkToast: FHKToast {
        inject.fhkToast
    }
    
    private var fhkConfiguration: FHKConfiguration {
        inject.fhkConfiguration
    }
    
    public enum Action: Equatable {
        case startTask
        case stopTask
        case validatePin
    }
    
    @MainActor
    public func action(_ action: Action) async {
        switch action {
            
        case .startTask:
            break
            
        case .stopTask:
            break
            
        case .validatePin:
            validateTasK()
        }
    }
    
    func displayNotification(message: String, type: ToastType = .warning) {
        fhkToast.show(viewState.toastInfo(msn: message, type: type))
    }
}

private extension FHKTaskStartScreenVM {
    
    func validateTasK() {
        let pinParent = fhkConfiguration.approvePin() ?? ""
        let pinEntered = viewState.approvePIN
        
        if pinEntered == pinParent {
            fhkToast.dismiss()
            viewState.startTaskState = .confirmation
        } else {
            displayNotification(message: viewState.msnPinApproveWrong,
                                type: .error)
        }
    }
}
