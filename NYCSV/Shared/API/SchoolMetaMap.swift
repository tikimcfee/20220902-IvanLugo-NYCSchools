//
//  SchoolMetaMap.swift
//  NYCSV
//
//  Created by Ivan Lugo on 8/31/22.
//

import Foundation

// Simple container struct for mapping between scores and school.
// We're allowing scores to be nil here; we will only present school
// details with known SAT scores. We can display missing items too.
struct SchoolMetaMap {
    var school: NYCSchool
    var scores: SATScoreModel?
}

extension SchoolMetaMap: Comparable {
    static func < (lhs: SchoolMetaMap, rhs: SchoolMetaMap) -> Bool {
        lhs.school.school_name < rhs.school.school_name
    }
    
    static func == (lhs: SchoolMetaMap, rhs: SchoolMetaMap) -> Bool {
        lhs.school.dbn == rhs.school.dbn
    }
}
