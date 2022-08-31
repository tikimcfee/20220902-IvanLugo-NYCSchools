//
//  Tests_iOS.swift
//  Tests iOS
//
//  Created by Ivan Lugo on 8/31/22.
//

import XCTest

class Tests_iOS: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        
    }

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()

    }

    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
