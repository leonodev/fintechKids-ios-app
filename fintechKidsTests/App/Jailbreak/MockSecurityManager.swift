//
//  MockSecurityManager.swift
//  fintechKids
//
//  Created by Fredy Leon on 6/1/26.
//

import XCTest
import FHKAuth
@testable import fintechKids

// MARK: - Mock to Simulate the Security Status
// We created a fake implementation of the JailbreakManagerProtocol.
class MockSecurityManager: JailbreakManagerProtocol {
    var shouldBeCompromised: Bool

    init(shouldBeCompromised: Bool) {
        self.shouldBeCompromised = shouldBeCompromised
    }

    var isDeviceCompromised: Bool {
        return shouldBeCompromised
    }
}


// MARK: - Los Tests Reales
final class SecurityManagerTests: XCTestCase {
    
    // The real SecurityManager should report 'false' in a simulator
    func testRealSecurityManager_shouldBeSafeInSimulator() {
    #if targetEnvironment(simulator)
        let realDetector = SecurityManager.shared
        XCTAssertFalse(realDetector.isDeviceCompromised, "El simulador debería ser reportado como no comprometido.")
    #else
        // Si estamos en un dispositivo físico, este test no es relevante,
        XCTFail("Este test solo es válido en el simulador y debería ser omitido en dispositivos físicos.")
    #endif
    }
    
    
    func testMockSecurityManager_shouldReportCompromised() {
        let compromisedDetector = MockSecurityManager(shouldBeCompromised: true)
        XCTAssertTrue(compromisedDetector.isDeviceCompromised, "El mock comprometido debería reportarse como True.")
    }
    
    
    func testMockSecurityManager_shouldReportSafe() {
        let safeDetector = MockSecurityManager(shouldBeCompromised: false)
        XCTAssertFalse(safeDetector.isDeviceCompromised, "El mock seguro debería reportarse como False.")
    }
    
    
    // Asegúrate de que la función del test sea 'async'
    @MainActor
    func testAppState_reactsToSecurityStatus() async {
        // Caso comprometido
        let compromisedMock = MockSecurityManager(shouldBeCompromised: true)
        
        // Al ser AppState @MainActor, debemos instanciarlo en el hilo principal usando await
        let compromisedAppState = AppState(detector: compromisedMock)
        
        XCTAssertTrue( compromisedAppState.isJailbroken, "AppState debería reflejar que el dispositivo está comprometido.")
        
        // Caso seguro
        let safeMock = MockSecurityManager(shouldBeCompromised: false)
        let safeAppState = AppState(detector: safeMock)
        
        XCTAssertFalse(safeAppState.isJailbroken, "AppState debería reflejar que el dispositivo está seguro.")
    }
    
}
