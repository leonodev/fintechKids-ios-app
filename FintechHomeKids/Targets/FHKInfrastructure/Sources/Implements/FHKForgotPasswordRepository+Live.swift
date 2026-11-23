//
//  FHKForgotPasswordRepository+Live.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 21/11/2026.
//

import FHKDomain
import FHKCore
import FLibInjections
import FLibStorage

public extension FHKForgotPasswordRepository {
    
    static var live: Self {
        var repo = Self()
        
        repo.forgot = { emailParent throws(FHKAppError) in
            let requestBody = FHKForgotPasswordRequestDto(emailParent: emailParent)
            
            let responseDto: FHKForgotPasswordResponseDto = try await FHKAPI.Builder()
                            .setPath(.forgotPassword)
                            .setBody(body: requestBody)
                            .setMethod(.POST)
                            .build()
                            .execute()
            
            return responseDto.toDomain()
        }
        
        repo.reset = { resetEntity throws(FHKAppError) in
            let responseDto: FHKResetPasswordResponseDto = try await FHKAPI.Builder()
                .setPath(.resetPassword)
                .setBody(body: resetEntity.toDto())
                .setMethod(.POST)
                .build()
                .execute()
            
            return responseDto.toDomain()
        }
        
        return repo
    }
}
