//
//  FHKRegisterRepository.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 4/9/26.
//

import Foundation

public struct FHKRegisterRepository: Sendable {
    public var register: @Sendable (_ registerEntity: FHKRegisterEntity) async throws -> FHKUserSession = { _ in
        throw NSError(domain: "FHKRegisterRepository.register no implementado", code: 0)
    }
    
    public var saveFamilyInfoKeychain: @Sendable (_ familyName: String) throws -> Void = { _ in }

    public init() {}
}
