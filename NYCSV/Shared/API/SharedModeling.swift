//
//  SharedModeling.swift
//  NYCSV
//
//  Created by Ivan Lugo on 8/31/22.
//

import Foundation

// Just to help know this is a special key
typealias DBNID = String

// Reused coders
struct Modeling {
    private init() { }
    static let defaultEncoder = JSONEncoder()
    static let defaultDecoder = JSONDecoder()
}

// Simple top-level parse as array list. We can be less picky about
// each model matching the scheme if we grab the root list from
// JSONSerialization and manually read from the dictionary, as an easy way.
protocol ListDecodable: Codable  {
    static func decodeAsList(from data: Data) throws -> [Self]
}

extension ListDecodable{
    static func decodeAsList(from data: Data) throws -> [Self] {
        try Modeling.defaultDecoder.decode(Array<Self>.self, from: data)
    }
}
