//
//  LoginScreenVMTest.swift
//  fintechKids
//
//  Created by fleon  on 8/6/26.
//

import XCTest
import FHKInjections
import FHKDomain
import Supabase
@testable import fintechKids
internal import FHKCore

@MainActor
final class LoginScreenVMTest: XCTestCase {
    
    func test_when_login_successfully_then_return_access_token() async throws {
        let loginRepositoryMock = LoginRepositoryMock()
        let client = try FHKDependencies.makeSupabaseClient()
        let supabaseMock = SupabaseMock(client: client)
        
        await inject.withOverrides {
            inject.fhkLoginRepository = loginRepositoryMock
            inject.fhkSupabase = supabaseMock
            
            let sut = LoginScreenVM()
            await sut.action(.doLogin)
            
            XCTAssertTrue(sut.viewState.loginState == .finish(result: .success))
        }
    }
    
    func test_when_login_successfully_then_error_save_access_token() async throws {
        let loginRepositoryMock = LoginRepositoryMock()
        let client = try FHKDependencies.makeSupabaseClient()
        let supabaseMock = SupabaseMock(client: client)
        let storageManagerMock = StorageManagerMock()
        
        await inject.withOverrides {
            inject.fhkStorage = storageManagerMock
            inject.fhkLoginRepository = loginRepositoryMock
            inject.fhkSupabase = supabaseMock
            storageManagerMock.mockError = FHKAppError.saveTokenAccessKeychainFailed
            
            let sut = LoginScreenVM()
            await sut.action(.doLogin)
            
            XCTAssertTrue(sut.viewState.loginState == .finish(result: .error))
            XCTAssertFalse(storageManagerMock.isCalledSaveKeychain)
            XCTAssertTrue(sut.viewState.msnLoginFail == "msn_proccessing_information_secure".localized())
        }
    }
    
    func test_when_supabase_login_fail_credentials_then_return_msn_error() async throws {
        let loginRepositoryMock = LoginRepositoryMock()
        let client = try FHKDependencies.makeSupabaseClient()
        let supabaseMock = SupabaseMock(client: client)
        
        supabaseMock.errorToThrow = FHKSupabaseError.invalidCredentials(context: nil)
        
        await inject.withOverrides {
            inject.fhkLoginRepository = loginRepositoryMock
            inject.fhkSupabase = supabaseMock
            
            let sut = LoginScreenVM()
            
            await sut.action(.doLogin)
            XCTAssertTrue(sut.viewState.loginState == .finish(result: .error))
            XCTAssertTrue(sut.viewState.msnLoginFail == "invalid_credentials_error".localized())
        }
    }
    
    func test_when_login_fail_credentials_then_return_msn_error() async throws {
        let loginRepositoryMock = LoginRepositoryMock()
        let client = try FHKDependencies.makeSupabaseClient()
        let supabaseMock = SupabaseMock(client: client)
        
        supabaseMock.errorToThrow = FHKLoginError.loginUserFailed
        
        await inject.withOverrides {
            inject.fhkLoginRepository = loginRepositoryMock
            inject.fhkSupabase = supabaseMock
            
            let sut = LoginScreenVM()
            
            await sut.action(.doLogin)
            XCTAssertTrue(sut.viewState.loginState == .finish(result: .error))
            XCTAssertTrue(sut.viewState.msnLoginFail == "invalid_credentials_error".localized())
        }
    }
    
    func test_when_login_success_not_returned_access_token_then_return_msn_error() async throws {
        let loginRepositoryMock = LoginRepositoryMock()
        let client = try FHKDependencies.makeSupabaseClient()
        let supabaseMock = SupabaseMock(client: client)
        
        let session = FHKUserSession(id: UUID(),
                                     email: "user@test.com",
                                     accessToken: nil,
                                     refreshToken: nil,
                                     expiresAt: nil,
                                     pinApproved: "1234")
        
        supabaseMock.session = session
        
        await inject.withOverrides {
            inject.fhkLoginRepository = loginRepositoryMock
            inject.fhkSupabase = supabaseMock
            
            let sut = LoginScreenVM()
            await sut.action(.doLogin)
            
            XCTAssertTrue(sut.viewState.loginState == .finish(result: .success))
            XCTAssertTrue(sut.viewState.msnLoginFail == "msn_generic_error".localized())
        }
    }
    
    func test_when_login_success_not_returned_pin_then_return_msn_error() async throws {
        let loginRepositoryMock = LoginRepositoryMock()
        let client = try FHKDependencies.makeSupabaseClient()
        let supabaseMock = SupabaseMock(client: client)
        
        let session = FHKUserSession(id: UUID(),
                                     email: "user@test.com",
                                     accessToken: "3FD345GHY345345DF",
                                     refreshToken: "FSDFSD234234FSD",
                                     expiresAt: nil,
                                     pinApproved: "")
        
        supabaseMock.session = session
        
        await inject.withOverrides {
            inject.fhkLoginRepository = loginRepositoryMock
            inject.fhkSupabase = supabaseMock
            
            let sut = LoginScreenVM()
            await sut.action(.doLogin)
            
            XCTAssertTrue(sut.viewState.loginState == .finish(result: .success))
            XCTAssertTrue(sut.viewState.msnLoginFail == "msn_generic_error".localized())
        }
    }
}



