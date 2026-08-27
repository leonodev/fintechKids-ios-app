//
//  DeepLinkHandler.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 26/8/26.
//

import Foundation

@MainActor
public protocol DeepLinkHandler: Sendable {
    func canHandle(url: URL) -> Bool
    func handle(url: URL)
}

@MainActor
public final class FHKDeepLinkRouter: Sendable {
    private var handlers: [DeepLinkHandler] = []

    public init(handlers: [DeepLinkHandler] = []) {
        self.handlers = handlers
    }

    public func register(handler: DeepLinkHandler) {
        handlers.append(handler)
    }

    public func handle(url: URL) {
        print("🚀 Processing Deep Link: \(url.absoluteString)")
        guard let handler = handlers.first(where: { $0.canHandle(url: url) }) else {
            print("⚠️ No handler registered for: \(url)")
            return
        }
        handler.handle(url: url)
    }
}
