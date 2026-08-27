//
//  FHKEnvironment+Mock.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 26/8/26.
//

import Foundation
import FHKCore

extension FHKEnvironment {
    
    static var test: Self {
        Self()
    }
    
    static var preview: Self {
        var view = Self()
        
        view.baseURL = {
            return "https://preview.fintechhomekids.com"
        }
        
        view.appName = {
            return "fintechhomekids-preview"
        }
        
        return view
    }
}
