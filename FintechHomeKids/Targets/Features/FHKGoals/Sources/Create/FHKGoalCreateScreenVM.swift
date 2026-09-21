//
//  FHKGoalCreateScreenVM.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 20/9/26.
//

import Foundation
import Observation
import FHKCore
import FLibInjections
import FHKDomain
import FLibUtils

@Observable
final class FHKGoalCreateScreenVM: FHKCore.ViewModel {
    var viewState: FHKGoalCreateViewState = .init()
    
    // Properties Injected
    private var fhkGoalsRepository: FHKGoalRepository {
        inject.fhkGoalsRepository
    }
    
    private var fhkConfiguration: FHKConfiguration {
        inject.fhkConfiguration
    }
    
    private var fhkFirebaseAnalitycs: FHKAnalytics {
        inject.fhkAnalitycs
    }
    
    public var fhkModal: FHKModal {
        inject.fhkModal
    }
    
    public var fhkToast: FHKToast {
        inject.fhkToast
    }
    
    public enum Action: Equatable {
        case createGoalWithTime
        case createGoalWithCoin
    }
    
    @MainActor
    public func action(_ action: Action) async {
        
        switch action {
            
        case .createGoalWithTime:
            await createNewGoalTime()
            
        case .createGoalWithCoin:
            await createNewGoalCoin()
        }
    }
    
    func getWorkType() -> FHKWorkType? {
        guard let rewardsType = viewState.selectedGoalType else {
            displayNotification(message: viewState.msnWarningMissingGoalType)
            return nil
        }
        
        return rewardsType
    }
}

private extension FHKGoalCreateScreenVM {
    
    func createNewGoalTime() async {
        do {
            guard let emailParent = getParentMail(), let goalValue = getGoalValue(), let durationType = getDurationType() else {
                return
            }
            
            viewState.goalState = .loading
            let goal = FHKGoalEntity(expirationDate: goalValue.futureDateString(unit: durationType),
                                  name: viewState.goalName.uppercased(),
                                  emailParent: emailParent,
                                  value: goalValue,
                                  measureType: durationType.value,
                                  status: .inCurse)
            
            try await fhkGoalsRepository.createGoal(goal)
            viewState.goalState = .finish(result: .success)
        } catch {
            informateError(FHKGoalError.createGoalFailed)
            viewState.goalState = .finish(result: .error)
        }
    }
    
    func createNewGoalCoin() async {
        do {
            guard let emailParent = getParentMail(), let goalValue = getGoalValue() else {
                return
            }
            
            viewState.goalState = .loading
            let goal = FHKGoalEntity(expirationDate: Date().ISO8601Format(),
                                  name: viewState.goalName.capitalizingFirstLetter(),
                                  emailParent: emailParent,
                                  value: goalValue,
                                  measureType: FHKWorkType.coins.value,
                                  status: .inCurse)
            
            try await fhkGoalsRepository.createGoal(goal)
            viewState.goalState = .finish(result: .success)
//        } catch let pgError as FHKSupabaseError {
//            informateError(pgError)
//            viewState.goalState = .finish(result: .error)
        } catch {
            informateError(FHKGoalError.createGoalFailed)
            viewState.goalState = .finish(result: .error)
        }
    }
    
    
    func getParentMail() -> String? {
        guard let emailParent = fhkConfiguration.parentMail() else {
            displayNotification(message: viewState.msnWarningMissingEmail, type: .error)
            return nil
        }
        
        return emailParent
    }
    
    func getGoalValue() -> Int? {
        guard let goalValue = Int(viewState.rewardsValue), goalValue > 0 else {
            displayNotification(message: viewState.msnWarningMissingValue)
            return nil
        }
        
        return goalValue
    }
    
    func getDurationType() -> FHKDurationType? {
        guard let durationType = viewState.selectedDurationType else {
            displayNotification(message: viewState.msnWarningMissingDuration)
            return nil
        }
        
        return durationType
    }
    
    func displayNotification(message: String, type: ToastType = .warning) {
        fhkToast.show(viewState.toastInfo(msn: message, type: type))
    }
    
    func informateError(_ error: any FHKError) {
        // We only send to Firebase if the error is configured to be reported.
        if error.isShouldTrack {
            fhkFirebaseAnalitycs.track(.error(.init(from: error)))
        }
        
        // We show the user the localized message (UX)
        viewState.msnUserError = error.msnLocalizedKey.localized
        
        // We print the full details to the console (Debug)
        Logger.error(error.logMessage)
    }
}
