//
//  SplashScreenVMTest.swift
//  fintechKidsTests
//
//  Created by Fredy Leon on 5/3/26.
//

import Testing
import Foundation
import FHKInjections
import FHKDomain
import FHKDomainTesting
@testable import fintechKids
internal import FHKCore

@MainActor
@Suite("Splash")
struct SplashScreenVMTest {

    @Test("Navigate to language screen, when no previous selection",
          .tags(.language))
    func goToLanguageScreen_when_notHasLanguagePreviuosSelected() async throws {
        try await assertStateWithCalled(
            withResult: .success(nil),
            thenExpects: .loaded(nav: .goToLanguage)
        )
    }

    @Test("Navigate to login screen, when has previous selection",
          .tags(.language))
    func goToLoginScreen_whenHasLanguagePreviuosSelected() async throws {
        try await assertStateWithCalled(
            withResult: .success("es"),
            thenExpects: .loaded(nav: .goToLogin)
        )
    }

    @Test("Navigate Langauge screen, when error reading language",
          .tags(.language))
    func goToLanguageScreen_whenErrorReadingLanguage() async throws {
        let mockError = NSError(domain: "Error", code: 401)

        try await assertStateWithCalled(
            withResult: .failure(mockError),
            thenExpects: .loaded(nav: .goToLanguage)
        )
    }
}

private extension SplashScreenVMTest {
    func assertStateWithCalled(
        withResult result: Result<String?, Error>,
        thenExpects expectedState: FHKSplashViewState.State
    ) async throws {
        let splashSpy = CallTracker()

        await inject.withOverrides {
            var customMock = FHKSplashRepository.test
            customMock.readLanguageCurrent = {
                splashSpy.increment()

                switch result {
                case .success(let language):
                    return language
                case .failure(let error):
                    throw error
                }
            }

            inject.fhkSplashRepository = customMock

            let sut = FHKSplashScreenVM()
            await sut.action(.readLanguageCurrent)

            #expect(sut.viewState.splashState == expectedState)
            #expect(splashSpy.isCalled)
            #expect(splashSpy.callCount == 1)
        }
    }
}
