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
        case scoreList = "f9bf-2cp4"
    }
    
    static func url(for file: BundleFile) -> URL? {
        Bundle.main.url(forResource: file.rawValue, withExtension: ".json")
    }
    
    static func sampleMetaList() -> [SchoolMetaPair] {
        guard let schools = url(for: .schoolList), let schoolData = try? Data(contentsOf: schools),
              let scores = url(for: .scoreList), let scoreData = try? Data(contentsOf: scores),
              let schoolList = try? SchoolModel.decodeAsList(from: schoolData),
              let scoreList = try? SATScoreModel.decodeAsList(from: scoreData)
        else { return [] }
        
        return Array(
            SchoolMetaPair
                .makeMapping(schools: schoolList, scores: scoreList)
                .values
        )
    }
}
