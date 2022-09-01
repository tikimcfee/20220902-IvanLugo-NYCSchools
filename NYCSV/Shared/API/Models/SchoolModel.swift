//
//  SchoolListModel.swift
//  NYCSV
//
//  Created by Ivan Lugo on 8/31/22.
//

import Foundation

struct NYCSchool: Codable, ListDecodable {    
    // Lookup for SAT Score ID
    let dbn: String

    // Semi-safe API items
    let city: String
    let zip: String
    let overview_paragraph: String
    let website: String
    let school_name: String
}
