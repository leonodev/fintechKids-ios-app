//
//  FHKForgotPasswordRepository.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 21/11/2026.
//

import FLibInjections
import FHKCore

// MARK: - Contract
public struct FHKForgotPasswordRepository: Sendable {
    
    public var forgot: @Sendable (String) async throws(FHKAppError) -> FHKForgotPasswordEntity = { _ in
        throw FHKAppError.unknown
        //FHKAuthError.forgotPassword
    }
    
    public var reset: @Sendable (_ entity: FHKResetPasswordEntity) async throws(FHKAppError) -> FHKResetPasswordResponseEntity = { _ in
        throw FHKAppError.unknown
    }
    
    public init() {}
}

// MARK: - KeyPath Access
public extension DependenciesInjection {
    
    var fhkForgotPasswordRepository: FHKForgotPasswordRepository {
        get { get(FHKForgotPasswordRepository.self, preview: .preview, testing: .test) }
        set { set(newValue, for: FHKForgotPasswordRepository.self) }
    }
}


// MARK: - Mocks & Previews
#if DEBUG
extension FHKForgotPasswordRepository {
    
    static var test: Self {
        Self()
    }
    
    static var preview: Self {
        var preview = Self()
        
        preview.forgot = { email in
            FHKForgotPasswordEntity(message: "A 6-digit verification code has been generated and sent to the registered email.",
                                    email: "parent@email.com",
                                    expiresInMinutes: 15,
                                    debugRecoveryCode: "482910"
            )
        }
        
        return preview
    }
}
#endif
