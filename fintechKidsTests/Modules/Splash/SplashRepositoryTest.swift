//
//  SplashRepositoryTest.swift
//  fintechKids
//
//  Created by fleon  on 8/6/26.
//

import XCTest
import FHKInjections
import FHKDomain
@testable import fintechKids
internal import FHKCore

@MainActor
final class SplashRepositoryTest: XCTestCase {
    
    func test_when_read_preview_language_selected_then_return_language() async throws {
        let storageMock = StorageManagerMock()
        
        try await inject.withOverrides {
            try await storageMock.saveUserDefaults("ES", forKey: "dummyKey")
            inject.fhkStorage = storageMock
            
            let sut = SplashRepository()
            let language = try await sut.readLanguageCurrent()
            
            XCTAssertTrue(storageMock.isCalledSaveUserDefaults)
            XCTAssertTrue(storageMock.mockStoredValue as? String == language)
        }
    }
    
    func test_when_language_no_has_selected_then_return_nil() async throws {
        let storageMock = StorageManagerMock()
        
        try await inject.withOverrides {
            inject.fhkStorage = storageMock
            
            let sut = SplashRepository()
            let language = try await sut.readLanguageCurrent()
            
            XCTAssertTrue(storageMock.isCalledReadUserDefaults)
            XCTAssertNil(language)
        }
    }
}
