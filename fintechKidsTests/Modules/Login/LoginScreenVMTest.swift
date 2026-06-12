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
import SwiftUI
@testable import fintechKids
internal import FHKCore
internal import FHKUtils

@MainActor
final class LoginScreenVMTest: XCTestCase {
    var loginRepositoryMock: LoginRepositoryMock!
    var toastMock: ToastMock!
    var modalMock: ModalMock!
    var securityMock: SecurityMock!
    
    
    private func setupMocks() {
        loginRepositoryMock = LoginRepositoryMock()
        toastMock = ToastMock()
        modalMock = ModalMock()
        securityMock = SecurityMock(type: .none)
    }
    
    func test_when_login_successfully_then_return_access_token() async throws {
        setupMocks()

        await inject.withOverrides {
            loginRepositoryMock.sessionToReturn = FHKUserSession.dummySessionSuccess()
            inject.fhkLoginRepository = loginRepositoryMock
            
            let sut = LoginScreenVM()
            await sut.action(.doLogin)
            
            XCTAssertEqual(sut.viewState.loginState, .finish(result: .success))
            XCTAssertTrue(loginRepositoryMock.isCalledLogin)
            XCTAssertNil(loginRepositoryMock.errorLoginToThrow)
        }
    }
    
    func test_when_login_supabase_failed_then_return_error() async throws {
        setupMocks()

        await inject.withOverrides {
            loginRepositoryMock.errorLoginToThrow = FHKSupabaseError.invalidCredentials(context: nil)
            inject.fhkLoginRepository = loginRepositoryMock
            
            let sut = LoginScreenVM()
            await sut.action(.doLogin)
            
            XCTAssertEqual(sut.viewState.loginState, .finish(result: .error))
            XCTAssertTrue(loginRepositoryMock.isCalledLogin)
            XCTAssertNil(loginRepositoryMock.sessionToReturn)
            XCTAssertEqual(sut.viewState.msnLoginFail, "invalid_credentials_error".localized())
        }
    }
    
    func test_when_login_successfully_then_msn_error_to_save_token() async throws {
        setupMocks()

        await inject.withOverrides {
            loginRepositoryMock.sessionToReturn = FHKUserSession.dummySessionSuccess()
            loginRepositoryMock.errorSaveTokenToThrow = FHKAppError.saveTokenAccessKeychainFailed
            
            inject.fhkLoginRepository = loginRepositoryMock
            
            let sut = LoginScreenVM()
            await sut.action(.doLogin)
            
            XCTAssertEqual(sut.viewState.loginState, .finish(result: .error))
            XCTAssertTrue(loginRepositoryMock.isCalledSaveAuthToken)
            XCTAssertEqual(loginRepositoryMock.isCalledSaveAuthTokenCount, 1)
            XCTAssertNotNil(loginRepositoryMock.errorSaveTokenToThrow)
            XCTAssertEqual(sut.viewState.msnLoginFail, "msn_proccessing_information_secure".localized())
        }
    }
    
    func test_when_login_successfully_then_error_to_save_user_into_keychain() async throws {
        setupMocks()

        await inject.withOverrides {
            loginRepositoryMock.sessionToReturn = FHKUserSession.dummySessionSuccess()
            loginRepositoryMock.errorSaveUserKeyChainToThrow = FHKAppError.saveUserMailKeychainFailed
            
            inject.fhkLoginRepository = loginRepositoryMock
            
            let sut = LoginScreenVM()
            await sut.action(.doLogin)
            
            XCTAssertEqual(sut.viewState.loginState, .finish(result: .error))
            XCTAssertTrue(loginRepositoryMock.isCalledSaveUserIntoKeychain)
            XCTAssertEqual(loginRepositoryMock.isCalledSaveUserIntoKeychainCount, 1)
            XCTAssertNotNil(loginRepositoryMock.errorSaveUserKeyChainToThrow)
        }
    }
    
    func test_when_login_successfully_then_error_save_pin_task_aproved() async throws {
        setupMocks()

        await inject.withOverrides {
            loginRepositoryMock.sessionToReturn = FHKUserSession.dummySessionSuccess()
            loginRepositoryMock.errorSavePinToThrow = FHKLoginError.pinApproveInvalid
            
            inject.fhkLoginRepository = loginRepositoryMock
            
            let sut = LoginScreenVM()
            await sut.action(.doLogin)
            
            XCTAssertEqual(sut.viewState.loginState, .finish(result: .error))
            XCTAssertTrue(loginRepositoryMock.isCalledSavePinApproveTask)
            XCTAssertEqual(loginRepositoryMock.isCalledSavePinApproveTaskCount, 1)
            XCTAssertNotNil(loginRepositoryMock.errorSavePinToThrow)
        }
    }
    
    func test_when_login_successfully_then_pin_task_aproved_no_exist() async throws {
        setupMocks()

        await inject.withOverrides {
            loginRepositoryMock.sessionToReturn = FHKUserSession.dummySessionSuccessWithoutPIN()
            inject.fhkLoginRepository = loginRepositoryMock
            
            let sut = LoginScreenVM()
            await sut.action(.doLogin)
            
            XCTAssertEqual(sut.viewState.loginState, .finish(result: .success))
            XCTAssertEqual(sut.viewState.msnLoginFail, "msn_generic_error".localized())
        }
    }
    
    func test_when_login_successfully_then_access_token_not_exist() async throws {
        setupMocks()

        await inject.withOverrides {
            loginRepositoryMock.sessionToReturn = FHKUserSession.dummySessionSuccessWithoutToken()
            inject.fhkLoginRepository = loginRepositoryMock
            
            let sut = LoginScreenVM()
            await sut.action(.doLogin)
            
            XCTAssertEqual(sut.viewState.loginState, .finish(result: .success))
            XCTAssertEqual(sut.viewState.msnLoginFail, "msn_generic_error".localized())
        }
    }
    
    func test_when_login_biometrics_successfully_then_state_success() async throws {
        setupMocks()

        await inject.withOverrides {
            loginRepositoryMock.sessionToReturn = FHKUserSession.dummySessionSuccess()
            inject.fhkLoginRepository = loginRepositoryMock
            
            let sut = LoginScreenVM()
            await sut.action(.doLoginWithBiometrics)
            
            XCTAssertEqual(sut.viewState.loginState, .finish(result: .success))
            XCTAssertTrue(loginRepositoryMock.isCalledLoginBiometrics)
            XCTAssertNil(loginRepositoryMock.errorLoginToThrow)
        }
    }
    
    func test_when_login_supabase_biometrics_fail_then_return_msn_error() async throws {
        setupMocks()

        await inject.withOverrides {
            loginRepositoryMock.errorLoginToThrow = FHKSupabaseError.accessToken
            inject.fhkLoginRepository = loginRepositoryMock
            
            let sut = LoginScreenVM()
            await sut.action(.doLoginWithBiometrics)
            
            XCTAssertEqual(sut.viewState.loginState, .finish(result: .error))
            XCTAssertTrue(loginRepositoryMock.isCalledLoginBiometrics)
            XCTAssertNotNil(loginRepositoryMock.errorLoginToThrow)
            XCTAssertEqual(sut.viewState.msnLoginFail, "msn_generic_error".localized())
            
        }
    }
    
    func test_when_login_supabase_cancel_biometrics_fail_then_return_state_error() async throws {
        setupMocks()

        await inject.withOverrides {
            loginRepositoryMock.errorLoginToThrow = FHKAppError.biometryCancelAuthentication
            inject.fhkLoginRepository = loginRepositoryMock
            
            let sut = LoginScreenVM()
            await sut.action(.doLoginWithBiometrics)
            
            XCTAssertEqual(sut.viewState.loginState, .finish(result: .error))
            XCTAssertTrue(loginRepositoryMock.isCalledLoginBiometrics)
            XCTAssertNotNil(loginRepositoryMock.errorLoginToThrow)
            
        }
    }
    
    func test_when_show_toast_then_display_toast() async {
        setupMocks()
        
        await inject.withOverrides {
            inject.fhkToast = toastMock
            
            let sut = LoginScreenVM()
            await sut.action(.showInfo(info: FHKToastInfo.dummyToastInfo()))
            
            XCTAssertTrue(toastMock.isCalledShow)
            XCTAssertEqual(toastMock.currentToast?.type, .success)
            XCTAssertTrue(toastMock.isVisible)
        }
    }
    
    func test_when_dismiss_toast_then_remove_toast() async {
        setupMocks()
        
        await inject.withOverrides {
            inject.fhkToast = toastMock
            
            let sut = LoginScreenVM()
            sut.fhkToast.dismiss()
            
            XCTAssertTrue(toastMock.isCalledShow)
            XCTAssertNil(toastMock.currentToast)
            XCTAssertFalse(toastMock.isVisible)
        }
    }
    
    func test_when_show_modal_then_display_modal() async {
        setupMocks()
        
        await inject.withOverrides {
            inject.fhkModal = modalMock
            
            let sut = LoginScreenVM()
            sut.fhkModal.show(onDismiss: {}, content: {})
            
            XCTAssertTrue(modalMock.isPresented)
        }
    }
    
    func test_when_dismiss_modal_then_remove_modal() async {
        setupMocks()
        
        await inject.withOverrides {
            inject.fhkModal = modalMock
            
            let sut = LoginScreenVM()
            sut.fhkModal.dismiss()
            
            XCTAssertFalse(modalMock.isPresented)
        }
    }
    
    func test_when_login_successfully_then_token_exist() async throws {
        setupMocks()

        await inject.withOverrides {
            loginRepositoryMock.sessionToReturn = FHKUserSession.dummySessionSuccess()
            inject.fhkLoginRepository = loginRepositoryMock
            
            let sut = LoginScreenVM()
            XCTAssertTrue(sut.hasSavedAuthToken)
        }
    }
    
    func test_when_faceid_biometric_enable_then_return_icon_faceid() async throws {
        setupMocks()
        
        await inject.withOverrides {
            securityMock.biometryType = .faceID
            inject.fhkSecurity = securityMock
            loginRepositoryMock.sessionToReturn = FHKUserSession.dummySessionSuccess()
            inject.fhkLoginRepository = loginRepositoryMock
            
            let sut = LoginScreenVM()
            await sut.action(.doLoginWithBiometrics)
            
            let icon = sut.biometryIconName
            XCTAssertEqual(icon, "faceid")
            XCTAssertEqual(sut.viewState.msnFaceId, "prompt_face_id".localized().capitalizingFirstLetter())
        }
    }
    
    func test_when_touchId_biometric_enable_then_return_icon_faceid() async throws {
        setupMocks()
        
        await inject.withOverrides {
            securityMock.biometryType = .touchID
            inject.fhkSecurity = securityMock
            loginRepositoryMock.sessionToReturn = FHKUserSession.dummySessionSuccess()
            inject.fhkLoginRepository = loginRepositoryMock
            
            let sut = LoginScreenVM()
            await sut.action(.doLoginWithBiometrics)
            
            let icon = sut.biometryIconName
            XCTAssertEqual(icon, "touchid")
            XCTAssertEqual(sut.viewState.msnTouchId, "prompt_touch_id".localized().capitalizingFirstLetter())
        }
    }
}

extension FHKUserSession {
    
     static func dummySessionSuccess() -> FHKUserSession {
        FHKUserSession(id: UUID(),
                       email: "user@test.com",
                       accessToken: "3FD345GHY345345DF",
                       refreshToken: "FSDFSD234234FSD",
                       expiresAt: Date(),
                       pinApproved: "1234")
    }
    
    static func dummySessionSuccessWithoutPIN() -> FHKUserSession {
       FHKUserSession(id: UUID(),
                      email: "user@test.com",
                      accessToken: "3FD345GHY345345DF",
                      refreshToken: "FSDFSD234234FSD",
                      expiresAt: Date(),
                      pinApproved: "")
   }
    
    static func dummySessionSuccessWithoutToken() -> FHKUserSession {
        FHKUserSession(id: UUID(),
                       email: "user@test.com",
                       accessToken: "",
                       refreshToken: "FSDFSD234234FSD",
                       expiresAt: Date(),
                       pinApproved: "1234")
    }
}

extension FHKToastInfo {
    
    static func dummyToastInfo() -> FHKToastInfo {
        FHKToastInfo(type: .success, message: "success", hasIcon: true)
    }
}
