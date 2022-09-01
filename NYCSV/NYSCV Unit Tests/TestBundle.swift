//
//  TestBundle.swift
//  NYSCV Unit Tests
//
//  Created by Ivan Lugo on 8/31/22.
//

import Foundation
import XCTest
@testable import NYCSV

class TestBundle {
    func loadData(for data: SampleData.BundleFile) throws -> Data {
        let maybeURL: URL? = SampleData.url(for: data)
        let fileURL = try XCTUnwrap(maybeURL, "Must have sample data in main bundle")
        print("Reading \(data) from: \(fileURL.lastPathComponent)")
        return try Data(contentsOf: fileURL)
    }
}

let lineSpace = Array(repeating: "\n", count: 3).joined()

func printStartDivider() {
    print(Array(repeating: "+", count: 32).joined(), lineSpace)
}

func printEndDivider() {
    print(lineSpace, Array(repeating: "-", count: 32).joined())
}
