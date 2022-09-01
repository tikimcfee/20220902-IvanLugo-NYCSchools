//
//  SchoolListModel.swift
//  NYCSV
//
//  Created by Ivan Lugo on 8/31/22.
//

import Foundation

struct SchoolModel: Hashable, ListDecodable {    
    // Lookup for SAT Score ID
    let dbn: DBNID

    // Semi-safe API items
    let city: String
    let zip: String
    let overview_paragraph: String
    let website: String
    let school_name: String
}
