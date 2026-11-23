//
//  FHKPath.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 18/11/2026.
//

import Foundation

public enum FHKPath: String, Sendable {
    case appVersion = "/api/v1/app-version/check"
    case register = "/api/v1/auth/register"
    case forgotPassword = "/api/v1/auth/forgot-password"
    case resetPassword = "/api/v1/auth/reset-password"
}
