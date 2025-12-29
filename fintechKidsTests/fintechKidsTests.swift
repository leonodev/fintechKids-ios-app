//
//  fintechKidsTests.swift
//  fintechKidsTests
//
//  Created by Fredy Leon on 10/11/25.
//

import XCTest
import ViewInspector
import SnapshotTesting
@testable import fintechKids

final class fintechKidsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMenu_language_Exist() throws {
        let languageView = LanguageScreen()
        let identifierMenuLanguage = "menu_language"
        let menuLanguage = try languageView.inspect().find(viewWithAccessibilityIdentifier: identifierMenuLanguage)
        
        XCTAssertNotNil(menuLanguage)
    }
    
    func testMenu_language_ScreenShot() throws {
        withSnapshotTesting(diffTool: .ksdiff) {
            let languageView = LanguageScreen()
            
            // Asegúrate de usar assertSnapshot con la vista y el nombre correcto del snapshot
            assertSnapshot(of: languageView, as: .image)
        }
    }
}
