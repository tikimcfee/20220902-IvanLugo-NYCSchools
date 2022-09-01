//
//  NYSCV_Unit_Tests.swift
//  NYSCV Unit Tests
//
//  Created by Ivan Lugo on 8/31/22.
//

import XCTest
@testable import NYCSV

class NYCSV_UnitTests: XCTestCase {
    
    var bundle: TestBundle!

    override func setUpWithError() throws {
        bundle = TestBundle()
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
    
    func testDBNMatching() throws {
        // DBN is a linking ID between SAT scores and Schools.
        // Some schools and scores are missing. Prepare a sample showing
        // what maps to what. We're assuming the 2017 data is more
        // accurate, and if missing SAT scores, we store that fact.
        
        let listData = try bundle.loadData(for: .schoolList)
        let schoolList = try SchoolModel.decodeAsList(from: listData)
        XCTAssertFalse(schoolList.isEmpty, "Must decode at least one school")
        
        let scoreData = try bundle.loadData(for: .scoreList)
        let scoreList = try SATScoreModel.decodeAsList(from: scoreData)
        XCTAssertFalse(scoreList.isEmpty, "Must decode at least one SAT score")
        
        let dbnMap = SchoolMetaPair.makeMapping(schools: schoolList, scores: scoreList)
        
        // Show stuff
        XCTAssertFalse(dbnMap.isEmpty, "Must have found at least one match")
        let sortedByEmpty = dbnMap.values.sorted()
        
        sortedByEmpty.forEach {
            print("""
            \($0.school.school_name):
            City: \($0.school.city)
            SAT Reading: \($0.scores?.sat_critical_reading_avg_score ?? "No scores")

            """)
        }
    }
}
