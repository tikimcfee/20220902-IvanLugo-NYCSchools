//
//  SharedModeling.swift
//  NYCSV
//
//  Created by Ivan Lugo on 8/31/22.
//

import Foundation

struct Modeling {
    private init() { }
    
    static let defaultEncoder = JSONDecoder()
    static let defaultDecoder = JSONDecoder()
}

protocol ListDecodable: Codable  {
    static func decodeAsList(from data: Data) throws -> [Self]
}

extension ListDecodable{
    // Simple top-level parse as array list. We can be less picky about
    // each model matching the scheme if we grab the root list from
    // JSONSerialization and manually read from the dictionary, as an easy way.
    static func decodeAsList(from data: Data) throws -> [Self] {
        try Modeling.defaultDecoder.decode(Array<Self>.self, from: data)
    }
}
