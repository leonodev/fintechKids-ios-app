//
//  FHKTasksRepository.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 27/9/26.
//

import Foundation
import FLibInjections

// MARK: - Contract
public struct FHKTasksRepository: Sendable {
    public var createTask:
    @Sendable(FHKTaskEntity) async throws -> Void = { _ in }
    
    public var getTasks:
    @Sendable(String, Bool) async throws -> [FHKTaskEntity] = { _, _ in  []}
    
    public var clearCache:
    @Sendable() async -> Void = {}
    
    public init() {}
}

// MARK: - KeyPath Access
public extension DependenciesInjection {
    
    var fhkTasksRepository: FHKTasksRepository {
        get { get(FHKTasksRepository.self, preview: .preview, testing: .test) }
        set { set(newValue, for: FHKTasksRepository.self) }
    }
}

// MARK: - Mocks & Previews
#if DEBUG
extension FHKTasksRepository {
    static var test: Self {
        Self()
    }
    
    static var preview: Self {
        var preview = Self()
        
        preview.createTask = { _ in }
        
        preview.getTasks = { _, _ in
            [FHKTaskEntity.previewItem]
        }
        
        preview.clearCache = { }
        
        return preview
    }
}
#endif
