//
//  FHKTasksRepository+Live.swift
//  fintechKids
//
//  Created by Fredy Leon on 12/3/26.
//

import FHKDomain
import FHKInjections
import FHKStorage
import FHKCore
import FHKUtils

public extension FHKTasksRepository {
    
    static var live: Self {
        let cache = TasksLiveCached()
        var tasksRepository = Self()
        
        tasksRepository.createTask = { taskList in
            try await inject.fhkSupabaseTask.createTask(taskList)
        }
        
        tasksRepository.getTasks = { emailParent, forceRefresh in
            // first ckeck if exist data in cache
            if let cachedList = await cache.getValidTasksCache(forceRefresh: forceRefresh) {
                Logger.info("📦 Return tasks list cached")
                return cachedList
            }
            
            Logger.info("🌐 Getting tasks list from backend")
            let taskList = try await inject.fhkSupabaseTask.getTasks(emailParent)
            await cache.setTasksCache(taskList)
            return taskList
        }
        
        tasksRepository.clearCache = {
            await cache.clearCache()
        }
        
        return tasksRepository
    }
}

private final actor TasksLiveCached {
    var tasksCache: CachedData<[TaskEntity]>?

    func getValidTasksCache(forceRefresh: Bool) async -> [TaskEntity]? {
        guard !forceRefresh, let cache = tasksCache, await !cache.isExpired() else {
            return nil
        }
        return cache.content
    }
    
    func setTasksCache(_ list: [TaskEntity]) {
        self.tasksCache = CachedData(content: list)
    }
    
    func clearCache() async {
        self.tasksCache = nil
    }
}
