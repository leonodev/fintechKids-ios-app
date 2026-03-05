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
        let mock = SplashRepositoryMock()
        
        await inject.withOverrides {
            inject[\.splashRepository] = mock
            
            let sut = SplashScreenVM()
            await sut.action(.readLanguageCurrent)
            
            let state = sut.viewState.splashState
            
            XCTAssertTrue(state == .finish(.goToLanguage))
            XCTAssertTrue(mock.isCalledReadLanguageCurrent)
            XCTAssertTrue(mock.readLanguageCurrentCallCount == 1) 
        }
    }
    
    func test_when_hasSelectPreviewLanguage_then_goToLoginScreen() async throws {
        let mock = SplashRepositoryMock()
        mock.mockLanguageResponse = "es"
        
        await inject.withOverrides {
            inject[\.splashRepository] = mock
            
            let sut = SplashScreenVM()
            await sut.action(.readLanguageCurrent)
            
            let state = sut.viewState.splashState
            
            XCTAssertTrue(state == .finish(.goToLogin))
            XCTAssertTrue(mock.isCalledReadLanguageCurrent)
            XCTAssertTrue(mock.readLanguageCurrentCallCount == 1)
        }
    }
    
    func test_when_hasErrorFromGetLanguage_then_goToLanguageScreen() async throws {
        let mock = SplashRepositoryMock()
        mock.mockError = FHKAppError.userDefaultsFailed
        
        await inject.withOverrides {
            inject[\.splashRepository] = mock
            
            let sut = SplashScreenVM()
            await sut.action(.readLanguageCurrent)
            
            let state = sut.viewState.splashState
            
            XCTAssertTrue(state == .finish(.goToLanguage))
            XCTAssertTrue(mock.isCalledReadLanguageCurrent)
            XCTAssertTrue(mock.readLanguageCurrentCallCount == 1)
        }
    }
}
