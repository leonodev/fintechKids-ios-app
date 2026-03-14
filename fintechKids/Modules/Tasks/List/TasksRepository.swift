//
//  TasksRepository.swift
//  fintechKids
//
//  Created by Fredy Leon on 12/3/26.
//

import FHKDomain
import FHKInjections
import FHKStorage
import FHKCore
import FHKUtils

final actor TasksRepository: FHKTasksRepositoryProtocol {
   
    // Properties injected
    private var fhkSupabaseTask: any FHKSupabaseTaskProtocol {
        inject.fhkSupabaseTask
    }
    
    private var tasksCache: CachedData<[TaskEntity]>?
    
    func createTask(task: FHKDomain.TaskEntity) async throws {
        try await fhkSupabaseTask.createTask(task: task)
    }
    
    func getTasks(emailParent: String, forceRefresh: Bool) async throws -> [TaskEntity] {
        if !forceRefresh, let cache = tasksCache, await !cache.isExpired() {
            Logger.info("📦 Return tasks list cached")
            return cache.content
        }
        
        Logger.info("🌐 Getting tasks list from backend")
        let taskList = try await fhkSupabaseTask.getTasks(parentEmail: emailParent)
        
        self.tasksCache = CachedData(content: taskList)
        return taskList
    }
    
    public func clearCache() async {
        self.tasksCache = nil
    }
}
