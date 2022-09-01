//
//  RequestVending.swift
//  NYSCV Unit Tests
//
//  Created by Ivan Lugo on 8/31/22.
//

import Foundation

protocol ListFetchable: ListDecodable {
    static var fetchPath: String { get }
    static var fetchRequest: ListFetch<Self>.Request { get }
}

extension ListFetchable {
    // We're compiling in these URLs. Theoretically, they're safe.
    // Hypothetically, parsing could change in the future and break everything.
    // That's fairly unlikely.
    static var fetchURL: URL { URL(string: fetchPath)! }
    static var fetchRequest: ListFetch<Self>.Request { .init(endpoint: Self.fetchURL) }
}

extension NYCSchool: ListFetchable {
    static var fetchPath: String { "https://data.cityofnewyork.us/resource/s3k6-pzi2.json" }
}

extension SATScoreModel: ListFetchable {
    static var fetchPath: String { "https://data.cityofnewyork.us/resource/f9bf-2cp4.json" }
}
