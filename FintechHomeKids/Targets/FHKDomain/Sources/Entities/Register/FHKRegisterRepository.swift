//
//  FHKRegisterRepository.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 4/9/26.
//

import Foundation
import FLibInjections
import FHKCore

// MARK: - Contract
public struct FHKRegisterRepository: Sendable {
    public var register: @Sendable (_ registerParams: FHKRegisterParams) async throws(FHKAppError) -> FHKRegisterEntity = { _ in
        throw FHKAppError.unknown
    }
    
    public var saveFamilyInfoKeychain: @Sendable (_ familyName: String) throws(FHKAppError) -> Void = { _ in }

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
            return FHKRegisterEntity(id: 1,
                                     createdAt: Date().toUTC,
                                     nameFamily: "Leon",
                                     emailParent: "user@example.com",
                                     approvePin: "1234",
                                     isActive: true,
                                     updatedAt: Date().toUTC)
        }
        
        return preview
    }
}

#endif
