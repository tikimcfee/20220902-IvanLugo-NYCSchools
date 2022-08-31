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
        
        print("Reading from: \(sampleURL.lastPathComponent)")
        
        // Root type is array, items are dictionaries
        let rawJSON = try Data(contentsOf: sampleURL)
        let jsonObject = try JSONSerialization.jsonObject(with: rawJSON)
        let dictionaryList = jsonObject as! Array<Dictionary<AnyHashable, Any>>
        
        // Grab all unique keys
        let uniqueKeys = dictionaryList.reduce(into: Set<String>()) { result, item in
            item.keys
                .compactMap { $0 as? String }
                .forEach { result.insert($0) }
        }
        let sortedKeys = uniqueKeys.sorted()
        
        // The dataset is nonhomgenous, and each dictionary has N keys with suffixed number maps.
        // We'll likely only show a handful of these. The API may (likely) has a spec to show all of them.
        print("All known root object keys:\n", sortedKeys)
    }
    
    
}
