//
//  LoginScreenVMTest.swift
//  fintechKids
//
//  Created by fleon  on 8/6/26.
//

import Testing
import FHKInjections
import FHKDomain
import Supabase
import SwiftUI
@testable import fintechKids
internal import FHKCore
internal import FHKUtils
internal import FHKStorage


@MainActor
struct LoginScreenVMTest {
    
    @Test("Return access token after login successfully",
          .tags(.login))
    func loginSuccessfully_then_returnAccessToken() async throws {
        let loginSpy = CallTracker()
        let registerSpy = CallTracker()

        await inject.withOverrides {
            configureDefaultMocks()

            var mockLoginRepository = inject.fhkLoginRepository
            mockLoginRepository.login = { _ in
                loginSpy.increment()
                return .sessionSuccessMock()
            }
            
            var mockRegisterRepository = inject.fhkRegisterRepository
            mockRegisterRepository.saveFamilyInfoKeychain = { _ in
                registerSpy.increment()
            }
            
            inject.fhkLoginRepository = mockLoginRepository
            inject.fhkRegisterRepository = mockRegisterRepository
            
            let sut = LoginScreenVM()
            await sut.action(.doLogin)
            
            #expect(sut.viewState.loginState == .finish(result: .success))
            
            // Asserts del repositorio de Login
            #expect(loginSpy.isCalled)
            #expect(loginSpy.callCount == 1)
            
            // Asserts del repositorio de Register
            #expect(registerSpy.isCalled)
            #expect(registerSpy.callCount == 1)
        }
    }
    
    @Test("Informate error when login not has access token valid",
          .tags(.login))
    func informateError_whenLoginSuccessNotHasAccessTokenValid() async throws {
        let loginSpy = CallTracker()

        await inject.withOverrides {
            configureDefaultMocks()
            
            var mockLoginRepository = inject.fhkLoginRepository
            mockLoginRepository.login = { _ in
                loginSpy.increment()
                return .sessionSuccessWithInvalidTokenMock()
            }
            
            inject.fhkLoginRepository = mockLoginRepository
            
            let sut = LoginScreenVM()
            await sut.action(.doLogin)
            
            #expect(loginSpy.callCount == 1)
            #expect(loginSpy.isCalled)
            #expect(sut.viewState.msnLoginFail == FHKLoginError.accessTokenInvalid.messageLocalized)
        }
    }
    
    @Test("Return Error type FHKSupabaseError when login in Supabase failed",
          .tags(.login))
    func loginSupabaseFailed_thenReturnSupabaseError() async throws {
        let loginSpy = CallTracker()

        await inject.withOverrides {
            configureDefaultMocks()
            
            var mockLoginRepository = inject.fhkLoginRepository
            mockLoginRepository.login = { _ in
                loginSpy.increment()
                throw FHKSupabaseError.invalidCredentials(context: nil)
            }
            
            inject.fhkLoginRepository = mockLoginRepository
            
            let sut = LoginScreenVM()
            await sut.action(.doLogin)
            
            #expect(sut.viewState.loginState == .finish(result: .error))
            #expect(loginSpy.callCount == 1)
            #expect(loginSpy.isCalled)
            #expect(sut.viewState.msnLoginFail == FHKSupabaseError.invalidCredentials(context: nil).messageLocalized)
        }
    }
    
    @Test("Return Error of type FHKLoginError when login in Supabase failed with error Unknown",
          .tags(.login))
    func loginSupabaseFailed_thenReturnGenericeError() async throws {
        let loginSpy = CallTracker()

        await inject.withOverrides {
            configureDefaultMocks()
            
            var mockLoginRepository = inject.fhkLoginRepository
            mockLoginRepository.login = { _ in
                loginSpy.increment()
                throw FHKLoginError.loginUserFailed
            }
            
            inject.fhkLoginRepository = mockLoginRepository
            
            let sut = LoginScreenVM()
            await sut.action(.doLogin)
            
            #expect(sut.viewState.loginState == .finish(result: .error))
            #expect(loginSpy.callCount == 1)
            #expect(loginSpy.isCalled)
            #expect(sut.viewState.msnLoginFail == FHKLoginError.loginUserFailed.messageLocalized)
        }
    }
    
    
    @Test("Return Error if login successfully but save session token failed",
          .tags(.login))
    func loginSuccessfully_then_msnErrorToSaveSessionToken() async throws {
        let loginSpy = CallTracker()
        let saveTokenSpy = CallTracker()
    
        await inject.withOverrides {
            configureDefaultMocks()
            
            var mockLoginRepository = inject.fhkLoginRepository
            mockLoginRepository.login = { _ in
                loginSpy.increment()
                return .sessionSuccessMock()
            }

            mockLoginRepository.saveAuthToken = { _, _ in
                saveTokenSpy.increment()
                throw FHKAppError.saveTokenAccessKeychainFailed
            }

            inject.fhkLoginRepository = mockLoginRepository
            
            let sut = LoginScreenVM()
            await sut.action(.doLogin)
            
            #expect(sut.viewState.loginState == .finish(result: .error))
            
            // Asserts del repositorio de Login
            #expect(loginSpy.isCalled)
            #expect(loginSpy.callCount == 1)
            
            // Asserts attemp save token by fail
            #expect(saveTokenSpy.isCalled)
            #expect(saveTokenSpy.callCount == 1)
        }
    }
    
    @Test("Return Error if login successfully but save family name is invalid",
          .tags(.login))
    func loginSuccessfully_then_msnErrorToSaveFamilyName() async throws {
        let loginSpy = CallTracker()
    
        await inject.withOverrides {
            configureDefaultMocks()
            
            var mockLoginRepository = inject.fhkLoginRepository
            mockLoginRepository.login = { _ in
                loginSpy.increment()
                return .sessionSuccessWithoutFamilyNameMock()
            }

            inject.fhkLoginRepository = mockLoginRepository
            
            let sut = LoginScreenVM()
            await sut.action(.doLogin)
            
            // Asserts del repositorio de Login
            #expect(loginSpy.isCalled)
            #expect(loginSpy.callCount == 1)
            
            // Asserts display error to user
            #expect(sut.viewState.msnLoginFail == FHKLoginError.familyNameInvalid.messageLocalized)
        }
    }
    
    @Test("Informate Error with login successfully but save family into keychain failed",
          .tags(.login))
    func loginSuccessfully_thenErrorToSaveFamilyNameKeychain() async throws {
        let loginSpy = CallTracker()
        let saveFamilyNameKeychainSpy = CallTracker()
    
        await inject.withOverrides {
            configureDefaultMocks()
            
            var mockLoginRepository = inject.fhkLoginRepository
            mockLoginRepository.login = { _ in
                loginSpy.increment()
                return .sessionSuccessMock()
            }
            
            var mockRegisterRepository = inject.fhkRegisterRepository
            mockRegisterRepository.saveFamilyInfoKeychain = { _ in
                saveFamilyNameKeychainSpy.increment()
                throw FHKLoginError.familyNameInvalid
            }
            
            inject.fhkRegisterRepository = mockRegisterRepository
            inject.fhkLoginRepository = mockLoginRepository
            
            let sut = LoginScreenVM()
            await sut.action(.doLogin)
            
            // Asserts del repositorio de Login
            #expect(loginSpy.isCalled)
            #expect(loginSpy.callCount == 1)
            
            // Asserts attemp save user into keychain by fail
            #expect(saveFamilyNameKeychainSpy.isCalled)
            #expect(saveFamilyNameKeychainSpy.callCount == 1)
        }
    }
    
    @Test("Return error if login successfully but save user into keychain failed",
          .tags(.login))
    func loginSuccessfully_thenErrorToSaveUserIntoKeychain() async throws {
        let loginSpy = CallTracker()
        let savUserKeyChainSpy = CallTracker()
    
        await inject.withOverrides {
            configureDefaultMocks()
            
            var mockLoginRepository = inject.fhkLoginRepository
            mockLoginRepository.login = { _ in
                loginSpy.increment()
                return .sessionSuccessMock()
            }
            
            mockLoginRepository.saveUserIntoKeychain = { _ in
                savUserKeyChainSpy.increment()
                throw FHKAppError.saveUserMailKeychainFailed
            }
            
            inject.fhkLoginRepository = mockLoginRepository
            
            let sut = LoginScreenVM()
            await sut.action(.doLogin)
            
            #expect(sut.viewState.loginState == .finish(result: .error))
            
            // Asserts del repositorio de Login
            #expect(loginSpy.isCalled)
            #expect(loginSpy.callCount == 1)
            
            // Asserts attemp save user into keychain by fail
            #expect(savUserKeyChainSpy.isCalled)
            #expect(savUserKeyChainSpy.callCount == 1)
        }
    }
    
    @Test("Return error if login successfully but save pin into keychain failed",
          .tags(.login))
    func loginSuccessfully_thenErrorSavePinTaskAproved() async throws {
        let loginSpy = CallTracker()
        let savePinSpy = CallTracker()
        
        await inject.withOverrides {
            configureDefaultMocks()
            
            var mockLoginRepository = inject.fhkLoginRepository
            mockLoginRepository.login = { _ in
                loginSpy.increment()
                return .sessionSuccessMock()
            }
            
            mockLoginRepository.savePinApproveTask = { _ in
                savePinSpy.increment()
                throw FHKLoginError.pinApproveInvalid
            }
            
            inject.fhkLoginRepository = mockLoginRepository
            
            let sut = LoginScreenVM()
            await sut.action(.doLogin)
            
            // Asserts called of Login
            #expect(loginSpy.isCalled)
            #expect(loginSpy.callCount == 1)
            
            // Asserts called of save pin
            #expect(savePinSpy.isCalled)
            #expect(savePinSpy.callCount == 1)
            
            // Asserts display error to user
            #expect(sut.viewState.msnLoginFail == FHKLoginError.pinApproveInvalid.messageLocalized)
        }
    }
    
    @Test("Display error to user if login successfully but pin task aproved not exist",
          .tags(.login))
    func loginSuccessfully_thenDisplayError_whenPinTaskAprovedNotExist() async throws {
        let loginSpy = CallTracker()
        
        await inject.withOverrides {
            configureDefaultMocks()
            
            var mockLoginRepository = inject.fhkLoginRepository
            mockLoginRepository.login = { _ in
                loginSpy.increment()
                return .sessionSuccessWithoutPinApprovedMock()
            }
            
            inject.fhkLoginRepository = mockLoginRepository
            
            let sut = LoginScreenVM()
            await sut.action(.doLogin)
            
            // Asserts del repositorio de Login
            #expect(loginSpy.isCalled)
            #expect(loginSpy.callCount == 1)
            #expect(sut.viewState.msnLoginFail == FHKLoginError.pinApproveInvalid.messageLocalized)
        }
    }
    
    
    @Test("Validate login with biometrics successfully",
          .tags(.login))
    func loginBiometricsSuccessfully_thenStateSuccess() async throws {
        let loginSpy = CallTracker()
        
        await inject.withOverrides {
            configureDefaultMocks()
            
            var mockLoginRepository = inject.fhkLoginRepository
            mockLoginRepository.loginWithBiometrics = { _ in
                loginSpy.increment()
            }
            
            inject.fhkLoginRepository = mockLoginRepository
            
            let sut = LoginScreenVM()
            await sut.action(.doLoginWithBiometrics)
            
            // Asserts called of Login
            #expect(loginSpy.isCalled)
            #expect(loginSpy.callCount == 1)
        }
    }
    
    @Test("Validate login with biometrics FaceID successfully",
          .tags(.login))
    func loginBiometricsFaceIDSuccessfully_thenStateSuccess() async throws {
        let loginSpy = CallTracker()
        let securitySpy = CallTracker()
        
        await inject.withOverrides {
            configureDefaultMocks()
            
            var mockLoginRepository = inject.fhkLoginRepository
            mockLoginRepository.loginWithBiometrics = { _ in
                loginSpy.increment()
            }
            
            var mockSecurityDevice = inject.fhkSecurity
            mockSecurityDevice.getBiometryType = {
                securitySpy.increment()
                return .faceID
            }
            
            inject.fhkLoginRepository = mockLoginRepository
            inject.fhkSecurity = mockSecurityDevice
            
            let sut = LoginScreenVM()
            await sut.action(.doLoginWithBiometrics)
            
            // Asserts called of Login
            #expect(loginSpy.isCalled)
            #expect(loginSpy.callCount == 1)
            
            // Asserts called of get biometry type
            #expect(securitySpy.isCalled)
            #expect(securitySpy.callCount == 1)
        }
    }
    
    @Test("Validate login with biometrics TouchID successfully",
          .tags(.login))
    func loginBiometricsTouchIDSuccessfully_thenStateSuccess() async throws {
        let loginSpy = CallTracker()
        let securitySpy = CallTracker()
        
        await inject.withOverrides {
            configureDefaultMocks()
            
            var mockLoginRepository = inject.fhkLoginRepository
            mockLoginRepository.loginWithBiometrics = { _ in
                loginSpy.increment()
            }
            
            var mockSecurityDevice = inject.fhkSecurity
            mockSecurityDevice.getBiometryType = {
                securitySpy.increment()
                return .touchID
            }
            
            inject.fhkLoginRepository = mockLoginRepository
            inject.fhkSecurity = mockSecurityDevice
            
            let sut = LoginScreenVM()
            await sut.action(.doLoginWithBiometrics)
            
            // Asserts called of Login
            #expect(loginSpy.isCalled)
            #expect(loginSpy.callCount == 1)
            
            // Asserts called of get biometry type
            #expect(securitySpy.isCalled)
            #expect(securitySpy.callCount == 1)
        }
    }
    
    @Test("Display error to user when login with biometrics fails",
          .tags(.login))
    func loginSupabaseBiometricsFail_thenShowUserErrorMsn() async throws {
        let loginSpy = CallTracker()
        
        await inject.withOverrides {
            configureDefaultMocks()
            
            var mockLoginRepository = inject.fhkLoginRepository
            mockLoginRepository.loginWithBiometrics = { _ in
                loginSpy.increment()
                throw FHKSupabaseError.accessToken
            }
            
            inject.fhkLoginRepository = mockLoginRepository
            
            let sut = LoginScreenVM()
            await sut.action(.doLoginWithBiometrics)
            
            #expect(sut.viewState.loginState == .finish(result: .error))
            
            // Asserts called of Login
            #expect(loginSpy.isCalled)
            #expect(loginSpy.callCount == 1)
            
            // Asserts display error to user
            #expect(sut.viewState.msnLoginFail == FHKSupabaseError.accessToken.messageLocalized)
        }
    }
    
    @Test("Display error generic to user when login with biometrics fails",
          .tags(.login))
    func loginSupabaseBiometricsFail_thenReturnMsnGenericError() async throws {
        let loginSpy = CallTracker()
        
        await inject.withOverrides {
            configureDefaultMocks()
            
            var mockLoginRepository = inject.fhkLoginRepository
            mockLoginRepository.loginWithBiometrics = { _ in
                loginSpy.increment()
                throw FHKAppError.biometryAuthenticationFailed
            }
            
            inject.fhkLoginRepository = mockLoginRepository
            
            let sut = LoginScreenVM()
            await sut.action(.doLoginWithBiometrics)
            
            #expect(sut.viewState.loginState == .finish(result: .error))
            
            // Asserts called of Login
            #expect(loginSpy.isCalled)
            #expect(loginSpy.callCount == 1)
            
            // Asserts display error to user
            #expect(sut.viewState.msnLoginFail == FHKAppError.biometryAuthenticationFailed.messageLocalized)
        }
    }
    
    @Test("Display toast when showInfo action is called",
          .tags(.showToast))
    func displayToast_thenShowToastIsCalled() async {
        let toastSpy = CallTracker()
        
        await inject.withOverrides {
            configureDefaultMocks()
            
            var mockToast = inject.fhkToast
            mockToast.show = { _, _ in
                toastSpy.increment()
            }
            
            inject.fhkToast = mockToast
  
            let sut = LoginScreenVM()
            await sut.action(.showInfo(info: FHKToastInfo(type: .success, message: "success", hasIcon: true)))
            
            // Asserts called
            #expect(toastSpy.isCalled)
            #expect(toastSpy.callCount == 1)
        }
    }
    
    
    private func configureDefaultMocks() {
        inject.fhkLoginRepository = .test
        inject.fhkRegisterRepository = .test
        inject.fhkStorage = .test
        inject.fhkToast = .test
        inject.fhkSecurity = .test
    }
}

extension FHKUserSession {
    static func sessionSuccessMock() -> FHKUserSession {
        let sessionMock = UserSessionMock()
            .withEmail("user@test.com")
            .withAccessToken("3FD345GHY345345DF")
            .withPin("1234")
            .withFamilyName("My Family")
            .build()
        
        return sessionMock
    }
    
    static func sessionSuccessWithoutPinApprovedMock() -> FHKUserSession {
        let sessionMock = UserSessionMock()
            .withEmail("user@test.com")
            .withAccessToken("3FD345GHY345345DF")
            .withFamilyName("My Family")
            .build()
        
        return sessionMock
    }
    
    static func sessionSuccessWithoutFamilyNameMock() -> FHKUserSession {
        let sessionMock = UserSessionMock()
            .withEmail("user@test.com")
            .withAccessToken("3FD345GHY345345DF")
            .withPin("1234")
            .build()
        
        return sessionMock
    }
    
    static func sessionSuccessWithInvalidTokenMock() -> FHKUserSession {
        let sessionMock = UserSessionMock()
            .withEmail("user@test.com")
            .build()

        return sessionMock
    }
}

struct UserSessionMock {
    private var email: String = ""
    private var accessToken: String?
    private var refreshToken: String?
    private var pin: String = ""
    private var familyName: String = ""

    func withEmail(_ email: String) -> Self {
        var copy = self
        copy.email = email
        return copy
    }
    
    func withAccessToken(_ accessToken: String) -> Self {
        var copy = self
        copy.accessToken = accessToken
        return copy
    }
    
    func withRefreshToken(_ refreshToken: String) -> Self {
        var copy = self
        copy.refreshToken = refreshToken
        return copy
    }
    
    func withPin(_ pin: String) -> Self {
        var copy = self
        copy.pin = pin
        return copy
    }
    
    func withFamilyName(_ familyName: String) -> Self {
        var copy = self
        copy.familyName = familyName
        return copy
    }

    func build() -> FHKUserSession {
        FHKUserSession(id: UUID(),
                       email: email,
                       accessToken: accessToken,
                       refreshToken: refreshToken,
                       expiresAt: Date(),
                       infoAditional: InfoAditional(pinApproved: pin, familyName: familyName))
    }
}

