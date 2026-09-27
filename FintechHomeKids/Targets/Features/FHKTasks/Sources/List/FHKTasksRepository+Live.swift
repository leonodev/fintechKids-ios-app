//
//  FHKTasksRepository+Live.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 27/9/26.
//

import Foundation
import FHKDomain
import FLibInjections
import FHKCore
import FLibUtils

public extension FHKTasksRepository {
    
    static var live: Self {
        let cache = TasksLiveCached()
        var tasksRepository = Self()
        
        tasksRepository.createTask = { task in
            try await inject.fhkTasks.createTask(task)
        }
        
        tasksRepository.getTasks = { emailParent, forceRefresh in
            if let cachedList = await cache.getValidTasksCache(forceRefresh: forceRefresh) {
                Logger.info("📦 Return Tasks list cached")
                return cachedList
            }
            
            Logger.info("🌐 Getting Tasks list from backend")
            let tasksList = try await inject.fhkTasks.getTasks(emailParent)
            await cache.setTasksCache(tasksList)
            return tasksList
        }
        
        tasksRepository.clearCache = {
            await cache.clearCache()
        }
        
        return tasksRepository
    }
}


private final actor TasksLiveCached {
    private var tasksCache: CachedData<[FHKTaskEntity]>?
    
    func getValidTasksCache(forceRefresh: Bool) async -> [FHKTaskEntity]? {
        guard !forceRefresh, let cache = tasksCache, await !cache.isExpired() else {
            return nil
        }
        return cache.content
    }
    
    func setTasksCache(_ list: [FHKTaskEntity]) {
        self.tasksCache = CachedData(content: list)
    }
    
    public func clearCache() async {
        self.tasksCache = nil
    }
}
