//
//  FHKTokenRefresher.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 27/11/2026.
//

import Foundation
import FHKCore

actor FHKTokenRefresher {
    static let shared = FHKTokenRefresher()
    private var activeRefreshTask: Task<String, Error>?
    
    func refreshAccessToken(environment: FHKEnvironmentType) async throws(FHKAppError) -> String {
        // If a refresh is already underway, we expect the same result.
        if let existingTask = activeRefreshTask {
            do {
                return try await existingTask.value
            } catch let appError as FHKAppError {
                throw appError
            } catch {
                throw .unauthorized
            }
        }
        
        let task = Task<String, Error> {
            guard let currentRefreshToken = inject.fhkConfiguration.refreshToken(),
                  !currentRefreshToken.isEmpty else {
                throw FHKAppError.unauthorized
            }
            
            let bodyDto = FHKRefreshTokenRequestDto(refreshToken: currentRefreshToken)
            
            let responseDto: FHKLoginResponseDto = try await FHKAPI.Builder()
                .setEnvironmentType(environment)
                .setPath(.refreshToken)
                .setMethod(.POST)
                .setBody(body: bodyDto)
                .build()
                .execute(retries: 0, allowTokenRefresh: false)
            
            try inject.fhkConfiguration.saveTokens(
                responseDto.accessToken,
                responseDto.refreshToken
            )
            
            return responseDto.accessToken
        }
        
        self.activeRefreshTask = task
        defer { self.activeRefreshTask = nil }
        
        do {
            return try await task.value
        } catch let appError as FHKAppError {
            // If the refresh_token has also expired (7 days have passed), we clear the session.
            try? inject.fhkConfiguration.deleteTokens()
            throw appError
        } catch {
            try? inject.fhkConfiguration.deleteTokens()
            throw .unauthorized
        }
    }
}
