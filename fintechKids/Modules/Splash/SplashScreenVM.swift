//
//  SplashScreenVM.swift
//  fintechKids
//
//  Created by Fredy Leon on 20/12/25.
//

import Observation
import FHKCore
import FHKInjections
import FHKDomain

@Observable
final class SplashScreenVM: FHKCore.ViewModel {
    var viewState: SplashViewState = .init()
    
    // Properties Injected
    private var fhkSplashRepository: any FHKSplashRepositoryProtocol {
        inject.fhkSplashRepository
    }
    
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
        // Creamos una tarea que actúa como guardián de tiempo (Timeout de 5 segundos)
        do {
            let isLanguageSelected = try await withTimeout(seconds: 5) {
                try await self.fhkSplashRepository.readLanguageCurrent()
            }
                    
            viewState.splashState = getStateUser(hasLanguageSelected: isLanguageSelected != nil)
        } catch {
            viewState.splashState = .loaded(nav: .goToLanguage)
        }
    }
    
    private func getStateUser(hasLanguageSelected: Bool) -> SplashViewState.State {
        if hasLanguageSelected {
            return .loaded(nav: .goToLogin)
        } else {
            return .loaded(nav: .goToLanguage)
        }
    }
    
    /// Ejecuta una operación asíncrona y lanza un error si supera el tiempo límite.
    func withTimeout<T>(seconds: UInt64, operation: @escaping @Sendable () async throws -> T) async throws -> T {
        try await withThrowingTaskGroup(of: T.self) { group in
            group.addTask {
                try await operation()
            }
            group.addTask {
                try await Task.sleep(nanoseconds: seconds * 1_000_000_000)
                throw CancellationError() // El timeout cancela el grupo
            }
            
            // 🔒 Desempaquetado seguro en lugar de usar "!"
            guard let result = try await group.next() else {
                group.cancelAll()
                throw CancellationError()
            }
            
            group.cancelAll() // Cancela la tarea que haya quedado viva (el sleep o la operación)
            return result
        }
    }
}
