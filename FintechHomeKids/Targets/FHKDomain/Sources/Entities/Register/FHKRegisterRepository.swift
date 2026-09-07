//
//  FHKRegisterRepository.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 4/9/26.
//

import Foundation
import FLibInjections

// MARK: - Contract
public struct FHKRegisterRepository: Sendable {
    public var register: @Sendable (_ registerEntity: FHKRegisterEntity) async throws -> FHKUserSession = { _ in
        throw NSError(domain: "FHKRegisterRepository.register no implementado", code: 0)
    }
    
    public var saveFamilyInfoKeychain: @Sendable (_ familyName: String) throws -> Void = { _ in }

    public init() {}
}

// MARK: - KeyPath Access
public extension DependenciesInjection {
    
    var fhkRegisterRepository: FHKRegisterRepository {
        get { get(FHKRegisterRepository.self) }
        set { set(newValue, for: FHKRegisterRepository.self) }
    }
}

// MARK: - Mocks & Previews
#if DEBUG
extension FHKRegisterRepository {
    static var test: Self {
        Self()
    }
    
    static var preview: Self {
        var preview = Self()
        
        preview.register = { _ in
            return FHKUserSession(id: UUID(),
                                  email: "user@domain.com",
                                  accessToken: "345345FDFDFTOKENTEST",
                                  refreshToken: "345345FDFDFREFRESHTOKENTEST",
                                  expiresAt: Date(),
                                  infoAditional: InfoAditional(pinApproved: "123", familyName: "FamilyTest"))
        }
        
        return preview
    }
}

#endif
