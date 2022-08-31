//
//  SampleData.swift
//  NYCSV
//
//  Created by Ivan Lugo on 8/31/22.
//

import Foundation

struct SampleData {
    private init() { }
    
    enum BundleFile: String {
        case schoolList = "s3k6-pzi2"
    }
    
    static func url(for file: BundleFile) -> URL? {
        Bundle.main.url(forResource: file.rawValue, withExtension: ".json")
    }
}
