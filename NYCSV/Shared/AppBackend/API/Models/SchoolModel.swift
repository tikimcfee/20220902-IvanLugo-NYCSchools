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
    
    // A slew of interesting optional parameters for display.
    // We could also use the other mentioned trick and use JSONSerialization
    // to map directly into these as well.
    // Run the unit test to pull more as you'd like.
    let program1: String?
    let program2: String?
    let program3: String?
    
    let academicopportunities1: String?
    let academicopportunities2: String?
    let academicopportunities3: String?
    
    let eligibility1: String?
    let eligibility2: String?
    let eligibility3: String?
    
    let interest1: String?
    let interest2: String?
    let interest3: String?
    
    let admissionspriority11: String?
    let admissionspriority12: String?
    let admissionspriority13: String?

    let directions1: String?
    let directions2: String?
    let directions3: String?
    
    let specialized: String?
    let school_accessibility_description: String?
    let advancedplacement_courses: String?
    let school_sports: String?
    
    let fax_number: String?
    let community_board: String?
    let school_email: String?}
