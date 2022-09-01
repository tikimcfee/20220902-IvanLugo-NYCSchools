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
struct SchoolMetaPair {
    var school: SchoolModel
    var scores: SATScoreModel?
}

typealias SchoolMetaMap = [DBNID: SchoolMetaPair]

extension SchoolMetaPair {
    static func makeMapping(
        schools: [SchoolModel],
        scores: [SATScoreModel]
    ) -> SchoolMetaMap {
        // Do a simple double loop through both lists to align schools with their scores.
        // This could probably be in a 'network DTO translation layer'. Against, 2 requests.
        // Also note: this is lossy on Scores; a missing school will drop it
        var dbnMap = [DBNID: SchoolMetaPair]()
        dbnMap = schools.reduce(into: dbnMap) { result, school in
            result[school.dbn] = SchoolMetaPair(school: school)
        }
        scores.forEach { dbnMap[$0.dbn]?.scores = $0 }
        return dbnMap
    }
}

extension SchoolMetaPair: Comparable {
    static func < (lhs: SchoolMetaPair, rhs: SchoolMetaPair) -> Bool {
        lhs.school.school_name < rhs.school.school_name
    }
    
    static func == (lhs: SchoolMetaPair, rhs: SchoolMetaPair) -> Bool {
        lhs.school.dbn == rhs.school.dbn
    }
}
