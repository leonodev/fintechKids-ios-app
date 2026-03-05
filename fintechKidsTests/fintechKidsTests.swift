//
//  fintechKidsTests.swift
//  fintechKidsTests
//
//  Created by Fredy Leon on 10/11/25.
//

import XCTest
import ViewInspector
import SnapshotTesting
import FHKInjections
@testable import fintechKids

final class fintechKidsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

//    func testMenu_language_Exist() throws {
//        let languageView = LanguageScreen()
//        let identifierMenuLanguage = "menu_language"
//        let menuLanguage = try languageView.inspect().find(viewWithAccessibilityIdentifier: identifierMenuLanguage)
//        
//        XCTAssertNotNil(menuLanguage)
//    }
//    
//    func testMenu_language_ScreenShot() throws {
//        withSnapshotTesting(diffTool: .ksdiff) {
//            let languageScreen = LanguageScreen()
//            
//            // Asegúrate de usar assertSnapshot con la vista y el nombre correcto del snapshot
//            assertSnapshot(of: languageScreen, as: .image)
//        }
//    }
//    
//    func test_cuando_se_guarda_idioma_el_viewmodel_actualiza_el_manager() async throws {
//        let mock = LanguageManagerMock()
//        
//        // 1. Seguimos usando withOverrides igual que antes
//        try await DependenciesInjection.shared.withOverrides({ injection in
//            // Seteamos el mock en el storage de la instancia shared
//            injection.set(mock, for: (any LanguageManagerProtocol).self)
//        }) {
//            // 2. Al instanciar el ViewModel aquí...
//            let viewModel = ContentViewModel()
//            
//            // 3. Cuando el VM haga: { deps.languageManager }
//            // 'deps' apunta a 'shared', y 'shared' ahora tiene el mock.
//            await viewModel.saveLanguage("it")
//            
//            XCTAssertTrue(mock.saveLanguageCalled)
//            XCTAssertEqual(mock.lastSavedLanguage, "it")
//        }
//    }
}
