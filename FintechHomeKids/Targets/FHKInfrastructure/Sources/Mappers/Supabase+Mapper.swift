//
//  Supabase+Mapper.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 6/9/26.
//

public protocol MappeableToSupabase {
    associatedtype ModelSupabase
    func toDto() throws -> ModelSupabase
}

extension Array: MappeableToSupabase where Element: MappeableToSupabase {
    public typealias ModelSupabase = [Element.ModelSupabase]
    
    public func toDto() throws -> ModelSupabase {
        try map { try $0.toDto() }
    }
}
