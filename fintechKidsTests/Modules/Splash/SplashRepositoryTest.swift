//
//  SplashRepositoryTest.swift
//  fintechKids
//
//  Created by fleon  on 8/6/26.
//

import Testing
import FHKInjections
import FHKDomain
@testable import fintechKids
internal import FHKCore
internal import FHKStorage

@MainActor
@Suite("Splash")
struct SplashRepositoryTest {
    //<verbo/resultado>_<condición>()
    @Test("Return language previous selected and saved",
          .tags(.language))
    func readPreviewLanguageSelected_thenReturnLanguage() async throws {
        let splashSpy = CallTracker()

        try await inject.withOverrides {
            inject.fhkStorage = FHKStorageManager.test
            
            let sut = FHKSplashRepository.live
            let language = try await sut.readLanguageCurrent()
            splashSpy.increment()
            
            #expect(language == "EN")
            #expect(splashSpy.isCalled)
            #expect(splashSpy.callCount == 1)
        }
    }
    
    @Test("Return nil if user not selected language previously",
          .tags(.language))
    func test_when_language_no_has_selected_then_return_nil() async throws {
        let splashSpy = CallTracker()
        
        var mockStorage = FHKStorageManager.test
        try await inject.withOverrides {
            inject.fhkStorage = mockStorage
            
            mockStorage.readUserDefaultsData = { _ in
                splashSpy.increment()
                return nil // We return whatever we want.
            }
            
            inject.fhkStorage = mockStorage
            let sut = FHKSplashRepository.live
            
            let language = try await sut.readLanguageCurrent()
            
            #expect(language == nil)
            #expect(splashSpy.isCalled)
            #expect(splashSpy.callCount == 1)
        }
    }
}
