//
//  FHKTask.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 27/9/26.
//

import Foundation
import FLibInjections

public struct FHKTasks: Sendable {
    public var createTask:
    @Sendable(FHKTaskEntity) async throws -> Void = { _ in }
    
    public var getTasks:
    @Sendable(String) async throws -> [FHKTaskEntity] = {_ in []}
    
    public init() {}
}

// MARK: - KeyPath Access
public extension DependenciesInjection {
    
    var fhkTasks: FHKTasks {
        get { get(FHKTasks.self, preview: .preview, testing: .test) }
        set { set(newValue, for: FHKTasks.self) }
    }
}

// MARK: - Mocks & Previews
#if DEBUG
extension FHKTasks {
    static var test: Self {
        Self()
    }
    
    static var preview: Self {
        var preview = Self()
        
        preview.createTask = { _ in }
        
        preview.getTasks = { _ in
            [FHKTaskEntity.previewItem]
        }
        
        return preview
    }
}
#endif
