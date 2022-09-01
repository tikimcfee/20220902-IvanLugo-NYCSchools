//
//  SATScoresModel.swift
//  NYCSV
//
//  Created by Ivan Lugo on 8/31/22.
//

import Foundation

struct SATScoreModel: ListDecodable {
    // Matching identifier to school
    let dbn: String
    
    // These are displayable numbers, and I'm deciding to
    // parse them for math later if I need to.
    let num_of_sat_test_takers: String
    let sat_critical_reading_avg_score: String
    let sat_math_avg_score: String
    let sat_writing_avg_score: String
}
