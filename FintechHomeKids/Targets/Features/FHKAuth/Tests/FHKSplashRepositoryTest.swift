//
//  FHKSplashRepositoryTest.swift
//  fintechKids
//
//  Created by fleon  on 8/6/26.
//

import Testing
import FLibInjections
import FHKDomain
@testable import FHKAuth
internal import FHKCore
internal import FLibStorage

@MainActor
@Suite("SplashRepository")
struct FHKSplashRepositoryTest {
    
    //<verbo/resultado>_<condición>()
    @Test("Return language previous selected and saved",
          .tags(.language))
    func readPreviewLanguageSelected_thenReturnLanguage() async throws {
        let splashSpy = CallTracker()

        try await inject.withOverrides { 
            await configureDefaultMocks()
            
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
        
        try await inject.withOverrides {
            var mockStorage = FHKStorageManager.test
            
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
    
    private func configureDefaultMocks() {
        inject.fhkStorage = FHKStorageManager.test
    }
}
