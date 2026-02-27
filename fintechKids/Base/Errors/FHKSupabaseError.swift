//
//  FHKSupabaseError.swift
//  fintechKids
//
//  Created by Fredy Leon on 27/2/26.
//

import Foundation

enum SupabaseError: LocalizedError {
    case invalidURL(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL(let url):
            return "Invalid Supabase URL: \(url)"
        }
    }
}
