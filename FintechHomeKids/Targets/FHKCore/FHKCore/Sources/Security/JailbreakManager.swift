//
//  JailbreakManager.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 26/8/26.
//

import SwiftUI
import Combine

public struct JailbreakManager: Sendable {
    public var isDeviceCompromised: @Sendable () -> Bool
    
    public init(isDeviceCompromised: @escaping @Sendable () -> Bool) {
        self.isDeviceCompromised = isDeviceCompromised
    }
}

public extension JailbreakManager {
    /// Implementación real para producción
    static let live = JailbreakManager(
        isDeviceCompromised: {
            #if targetEnvironment(simulator)
            return false
            #else
            return checkSuspiciousFiles() ||
                   checkSystemPaths() ||
                   checkCydiaCanBeOpened() ||
                   canForkProcess()
            #endif
        }
    )
}

// MARK: - Detectores Privados

private func checkSuspiciousFiles() -> Bool {
    let paths = [
        "/Applications/Cydia.app",
        "/Library/MobileSubstrate/MobileSubstrate.dylib",
        "/bin/bash",
        "/usr/sbin/sshd",
        "/etc/apt",
        "/private/var/lib/apt/"
    ]
    return paths.contains { FileManager.default.fileExists(atPath: $0) }
}

private func checkSystemPaths() -> Bool {
    let path = "/private/jailbreak_test.txt"
    do {
        try "test".write(toFile: path, atomically: true, encoding: .utf8)
        try FileManager.default.removeItem(atPath: path)
        return true
    } catch {
        return false
    }
}

private func checkCydiaCanBeOpened() -> Bool {
    guard let url = URL(string: "cydia://package/com.example.package") else { return false }
    
    // Evita Deadlocks verificando si ya estamos en el hilo principal
    if Thread.isMainThread {
        return MainActor.assumeIsolated { UIApplication.shared.canOpenURL(url) }
    } else {
        return DispatchQueue.main.sync {
            UIApplication.shared.canOpenURL(url)
        }
    }
}

private func canForkProcess() -> Bool {
    typealias ForkFunction = @convention(c) () -> Int32
    
    let handle = dlopen(nil, RTLD_NOW)
    if let symbol = dlsym(handle, "fork") {
        let fork = unsafeBitCast(symbol, to: ForkFunction.self)
        let pid = fork()
        
        if pid >= 0 {
            if pid > 0 {
                kill(pid, SIGTERM)
            }
            return true
        }
    }
    return false
}


