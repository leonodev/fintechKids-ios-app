//
//  SplashScreenVMTest.swift
//  fintechKidsTests
//
//  Created by Fredy Leon on 5/3/26.
//

import XCTest
import FHKInjections
import FHKDomain
@testable import fintechKids
internal import FHKCore

@MainActor
final class SplashScreenVMTest: XCTestCase {
    
    func test_when_notHasSelectPreviewLanguage_then_goToLanguageScreen() async throws {
        let splashMock = SplashRepositoryMock()
        
        await inject.withOverrides {
            inject.fhkSplashRepository = splashMock
            
            let sut = SplashScreenVM()
            await sut.action(.readLanguageCurrent)
            
            let state = sut.viewState.splashState
            
            XCTAssertTrue(state == .loaded(nav: .goToLanguage))
            XCTAssertTrue(splashMock.isCalledReadLanguageCurrent)
            XCTAssertTrue(splashMock.readLanguageCurrentCallCount == 1) 
        }
    }
    
    func test_when_hasSelectPreviewLanguageAndNotTokenLogin_then_goToLoginScreen() async throws {
        let loginMock = LoginRepositoryMock()
        let splashMock = SplashRepositoryMock()
        
        await inject.withOverrides {
            splashMock.languageSelected = "es"
            
            inject.fhkLoginRepository = loginMock
            inject.fhkSplashRepository = splashMock
            
            let sut = SplashScreenVM()
            await sut.action(.readLanguageCurrent)
            
            let state = sut.viewState.splashState
            XCTAssertTrue(state == .loaded(nav: .goToLogin))
            XCTAssertTrue(splashMock.isCalledReadLanguageCurrent)
            XCTAssertTrue(splashMock.readLanguageCurrentCallCount == 1)
        }
    }
    
    func test_when_hasErrorFromGetLanguage_then_goToLanguageScreen() async throws {
        let mock = SplashRepositoryMock()
        mock.mockError = FHKAppError.userDefaultsFailed
        
        await inject.withOverrides {
            inject.fhkSplashRepository = mock
            
            let sut = SplashScreenVM()
            await sut.action(.readLanguageCurrent)
            
            let state = sut.viewState.splashState
            
            XCTAssertTrue(state == .loaded(nav: .goToLanguage))
            XCTAssertTrue(mock.isCalledReadLanguageCurrent)
            XCTAssertTrue(mock.readLanguageCurrentCallCount == 1)
        }
    }
}
