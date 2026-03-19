//
//  GoalScreenVM.swift
//  fintechKids
//
//  Created by Fredy Leon on 15/3/26.
//

import Foundation
import Observation
import FHKCore
import FHKInjections
import FHKDomain
import FHKFirebase
import FHKUtils

@Observable
final class GoalScreenVM: FHKCore.ViewModel {
    var viewState: GoalViewState = .init()
    
    // Properties Injected
    private var fhkGoalsRepository: any FHKGoalRepositoryProtocol {
        inject.fhkGoalsRepository
    }
    
    private var fhkConfiguration: any FHKConfigurationProtocol {
        inject.fhkConfiguration
    }
    
    private var fhkFirebaseAnalitycs: any FHKAnalyticsProtocol {
        inject.fhkFirebaseAnalitycs
    }
    
    public var fhkModal: any FHKModalProtocol {
        inject.fhkModal
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
    
    func getWorkType() -> WorkType? {
        guard let rewardsType = viewState.selectedGoalType else {
            informateError(FHKGoalError.rewardsTypeInvalid)
            viewState.goalState = .finish(result: .error)
            return nil
        }
        
        return rewardsType
    }
}

private extension GoalScreenVM {
    
    func createNewGoalTime() async {
        viewState.goalState = .loading
        
        do {
            guard let emailParent = getParentMail(), let goalValue = getGoalValue(), let durationType = getDurationType() else {
                return
            }
            
            let goal = GoalEntity(expirationDate: goalValue.futureDateString(unit: durationType),
                                  name: viewState.goalName.capitalizingFirstLetter(),
                                  emailParent: emailParent,
                                  value: goalValue,
                                  measureType: WorkType.time.value,
                                  status: .inCurse)
            
            try await fhkGoalsRepository.createGoal(goal: goal)
            viewState.goalState = .finish(result: .success)
        } catch {
            informateError(FHKGoalError.createGoalFailed)
            viewState.goalState = .finish(result: .error)
        }
    }
    
    func createNewGoalCoin() async {
        viewState.goalState = .loading
        
        do {
            guard let emailParent = getParentMail(), let goalValue = getGoalValue() else {
                return
            }

            let goal = GoalEntity(expirationDate: "",
                                  name: viewState.goalName.capitalizingFirstLetter(),
                                  emailParent: emailParent,
                                  value: goalValue,
                                  measureType: WorkType.coins.value,
                                  status: .inCurse)
            
            try await fhkGoalsRepository.createGoal(goal: goal)
            viewState.goalState = .finish(result: .success)
        } catch let pgError as FHKSupabaseError {
            informateError(pgError)
            viewState.goalState = .finish(result: .error)
        } catch {
            informateError(FHKGoalError.createGoalFailed)
            viewState.goalState = .finish(result: .error)
        }
    }
    
    func getParentMail() -> String? {
        guard let emailParent = fhkConfiguration.parentMail else {
            informateError(FHKAppError.readUserMailKeychainFailed)
            viewState.goalState = .finish(result: .error)
            return nil
        }
        
        return emailParent
    }
    
    func getGoalValue() -> Int? {
        guard let goalValue = Int(viewState.rewardsValue), goalValue > 0 else {
            informateError(FHKGoalError.createGoalFailed)
            viewState.goalState = .finish(result: .error)
            return nil
        }
        
        return goalValue
    }
    
    func getDurationType() -> DurationType? {
        guard let durationType = viewState.selectedDurationType else {
            informateError(FHKGoalError.durationTypeInvalid)
            viewState.goalState = .finish(result: .error)
            return nil
        }
        
        return durationType
    }
    
    func informateError(_ error: any FHKError) {
        if error.isShouldTrack {
            fhkFirebaseAnalitycs.track(.error(.init(from: error)))
        }
        
        viewState.msnUserError = error.messageLocalized
        Logger.error(error.logMessage)
    }
}
