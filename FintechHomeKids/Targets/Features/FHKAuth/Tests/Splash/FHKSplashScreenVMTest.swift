//
//  FHKSplashScreenVMTest.swift
//  fintechKidsTests
//
//  Created by Fredy Leon on 5/3/26.
//

import Testing
import Foundation
import FLibInjections
import FHKDomain
@testable import FHKAuth
internal import FHKCore

@Suite("Splash")
struct FHKSplashScreenVMTest {

    @Test("Navigate to language screen, when no previous selection",
          .tags(.language))
    func goToLanguageScreen_when_notHasLanguagePreviuosSelected() async throws {
        let splashSpy = CallTracker()
        
        await inject.withOverrides {
            // configue mock login
            var loginMock = FHKLoginRepository.test
            loginMock.hasSavedToken = { false }
            inject.fhkLoginRepository = loginMock
            
            
            // configue mock splash
            var splashMock = FHKSplashRepository.test
            splashMock.readLanguageCurrent = {
                splashSpy.increment()
                return nil
            }
            inject.fhkSplashRepository = splashMock
            
            let sut = await FHKSplashScreenVM()
            await sut.action(.readLanguageCurrent)
            
            let currentState = await MainActor.run { sut.viewState.splashState }
            
            //Assetions
            #expect(currentState == .loaded(nav: .goToLanguage))
            #expect(splashSpy.isCalled)
            #expect(splashSpy.callCount == 1)
        }
    }

    @Test("Navigate to login screen, when has previous selection",
          .tags(.language))
    func goToLoginScreen_whenHasLanguagePreviousSelected() async throws {
        let splashSpy = CallTracker()
        
        await inject.withOverrides {
            // configue mock login
            var loginMock = FHKLoginRepository.test
            loginMock.hasSavedToken = { false }
            inject.fhkLoginRepository = loginMock
            
            // configue mock splash
            var splashMock = FHKSplashRepository.test
            splashMock.readLanguageCurrent = {
                splashSpy.increment()
                return "es"
            }
            inject.fhkSplashRepository = splashMock
            
            
            let sut = await FHKSplashScreenVM()
            await sut.action(.readLanguageCurrent)
            
            let currentState = await MainActor.run { sut.viewState.splashState }
            
            //Assetions
            #expect(currentState == .loaded(nav: .goToLogin))
            #expect(splashSpy.isCalled)
            #expect(splashSpy.callCount == 1)
        }
    }

    @Test("Navigate language screen, when error reading language",
          .tags(.language))
    func goToLanguageScreen_when_errorReadingLanguage() async throws {
        let mockError = NSError(domain: "Error", code: 401)
        
        await inject.withOverrides {
            let splashSpy = CallTracker()
            
            // configue mock splash
            var splashMock = FHKSplashRepository.test
            splashMock.readLanguageCurrent = {
                splashSpy.increment()
                throw mockError
            }
            inject.fhkSplashRepository = splashMock
            
            let sut = await FHKSplashScreenVM()
            await sut.action(.readLanguageCurrent)
            
            let currentState = await MainActor.run { sut.viewState.splashState }
            
            //Assetions
            #expect(currentState == .loaded(nav: .goToLanguage))
            #expect(splashSpy.isCalled)
            #expect(splashSpy.callCount == 1)
        }
    }
    
    @Test("Navigate Home screen, when has language selected",
          .tags(.language))
    func goToHomeScreen_when_hasLanguagePreviuosSelected() async throws {
        let splashSpy = CallTracker()
        
        await inject.withOverrides {
            // configue mock login
            var loginMock = FHKLoginRepository.test
            loginMock.hasSavedToken = { true }
            inject.fhkLoginRepository = loginMock
            
            // configue mock splash
            var splashMock = FHKSplashRepository.test
            splashMock.readLanguageCurrent = {
                splashSpy.increment()
                return "es"
            }
            inject.fhkSplashRepository = splashMock
            
            let sut = await FHKSplashScreenVM()
            await sut.action(.readLanguageCurrent)
            
            let currentState = await MainActor.run { sut.viewState.splashState }
            
            //Assetions
            #expect(currentState == .loaded(nav: .gotoHome))
            #expect(splashSpy.isCalled)
            #expect(splashSpy.callCount == 1)
        }
    }
}
