//
//  AnalyticsEvent.swift
//  FHKFirebase
//
//  Created by Fredy Leon on 28/2/26.
//

import Foundation

public enum AnalyticsEvent: Sendable {
    case screenView(Screen)
    case tapButton(Button)
    case error(ErrorDetail)
    
    public struct Screen: Equatable, Sendable {
        public let name: String
        public let screenClass: String
        
        public init(name: String, screenClass: String) {
            self.name = name
            self.screenClass = screenClass
        }
    }
    
    public struct Button: Equatable, Sendable {
        public let name: String
        
        public init(name: String) {
            self.name = name
        }
    }
    
    public struct ErrorDetail: Equatable, Sendable {
        public let type: String
        public let message: String
        
        public init(from fhkError: some FHKError) {
            self.type = fhkError.analyticsIdentifier ?? "unknown_error"
            self.message = fhkError.logMessage
        }
    }
}

public extension AnalyticsEvent {
    var name: String {
        switch self {
        case .screenView: return "screen_view"
        case .tapButton: return "tap_button"
        case .error: return "app_error"
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .screenView(let screen):
            return ["screen_name": screen.name, "screen_class": screen.screenClass]
        case .tapButton(let button):
            return ["button_name": button.name]
        case .error(let detail):
            return ["error_type": detail.type, "error_detail": detail.message]
        }
    }
}
