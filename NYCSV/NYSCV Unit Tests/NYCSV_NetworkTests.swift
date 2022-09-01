//
//  NYCSV_NetworkTests.swift
//  NYSCV Unit Tests
//
//  Created by Ivan Lugo on 8/31/22.
//
import XCTest
@testable import NYCSV

class NYCSV_NetworkTests: XCTestCase {
    
    var bundle: TestBundle!
    var networking: Networking!
    
    override func setUpWithError() throws {
        bundle = TestBundle()
        networking = Networking()
        
        printStartDivider()
    }
    
    override func tearDownWithError() throws {
        printEndDivider()
    }
    
    func testFetchSchoolList() throws {
        let listExpectation = expectation(description: "Must fetch and receive callback from request")
        
        let request = SchoolModel.fetchRequest
        networking.doFetch(request) { schoolResponse in
            switch schoolResponse.result {
            case let .success(list):
                print("Found schools: \(list.count)")
                
            case let .failure(error):
                XCTFail("Failed to fetch schools with error: \(error)")
                
            }
            listExpectation.fulfill()
        }
        
        wait(for: [listExpectation], timeout: 3.0)
    }
    
    func testSimultaneousFetch() throws {
        let fetchCompletes = expectation(description: "meta fetcher much complete its tasks")
        let metaFetch = SchoolMetaFetcher(networking) { result in
            switch result {
            case let .success(map):
                XCTAssertFalse(map.keys.isEmpty, "API request is expected to have at least one value")
                print("Received map with keys: \(map.keys.count)")
                
            case let .failure(error):
                switch error {
                case let .multiFetch(allErrors):
                    let message = allErrors.map { $0.localizedDescription }.joined(separator: "\n")
                    XCTFail(message)
                }
            }
            fetchCompletes.fulfill()
        }
        metaFetch.start()
        wait(for: [fetchCompletes], timeout: 5.0)
    }
}
