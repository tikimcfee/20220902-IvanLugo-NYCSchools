//
//  NYSCV_Unit_Tests.swift
//  NYSCV Unit Tests
//
//  Created by Ivan Lugo on 8/31/22.
//

import XCTest
@testable import NYCSV

class NYSCV_Unit_Tests: XCTestCase {

    override func setUpWithError() throws {
        printStartDivider()
    }

    override func tearDownWithError() throws {
        printEndDivider()
    }
    
    func testSchoolListJSON() throws {
        let listFile: URL? = SampleData.url(for:.schoolList)
        let sampleURL = try XCTUnwrap(listFile, "Must have sample data in main bundle")
        
        print("Reading from: \(sampleURL)")
        

    }
}
