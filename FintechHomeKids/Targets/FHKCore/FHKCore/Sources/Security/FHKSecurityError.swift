//
//  FHKSecurityError.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 31/8/26.
//

import Foundation

public enum FHKSecurityError: Error {
    case cryptoError(String)
    case invalidKeyData
}
