//
//  FHKTasks+Live.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 11/11/2026.
//

import Foundation
import FHKDomain
import FLibInjections
import Supabase

public extension FHKTasks {
    
    static func live(supabaseClient: SupabaseClient) -> Self {
        var repository = Self()
        let supabaseTask = FHKSupabaseTask(supabaseClient: supabaseClient)
        
        repository.createTask = { task in
            try await supabaseTask.createTask(task: task)
        }
        
        repository.getTasks = { emailParent in
            try await supabaseTask.fetchTaskList(parentEmail: emailParent)
        }
        
        return repository
    }
}
