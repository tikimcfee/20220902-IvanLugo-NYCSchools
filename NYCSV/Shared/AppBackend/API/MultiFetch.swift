//
//  File.swift
//  NYCSV
//
//  Created by Ivan Lugo on 8/31/22.
//

import Foundation

// Rather than nested requested, launch a few and await all results.
// We could use some Combine operators here, maybe using a disposable
// set to zip together results. Not everyone likes Combine, though. Or
// reactive streams for that matter. Everyone hates callbacks. So,
// let's do that one.
class SchoolMetaFetcher {
    enum Failure: Error {
        case multiFetch([Error])
    }
    
    typealias Receiver = (Result<SchoolMetaMap, SchoolMetaFetcher.Failure>) -> Void
    let networking: Networking
    let receiver: Receiver
    
    private var schoolList: ListFetch<SchoolModel>.Response? { didSet { checkResults() } }
    private var satScores: ListFetch<SATScoreModel>.Response? { didSet { checkResults() } }
    
    init(_ networking: Networking, _ receiver: @escaping Receiver) {
        self.networking = networking
        self.receiver = receiver
    }
    
    func start() {
        networking.doFetch(SchoolModel.fetchRequest) { self.schoolList = $0 }
        networking.doFetch(SATScoreModel.fetchRequest) { self.satScores = $0 }
    }
    
    private func checkResults() {
        guard let schoolList = schoolList else { return }
        guard let satScores = satScores else { return }
        print("Received all fetch resposnes")
        
        switch (schoolList.result, satScores.result) {
        case let (.success(schools), .success(satScores)):
            onSuccess(schools: schools, scores: satScores)
        default: // one of these is an error
            let errors = [
                schoolList.result.maybeError,
                satScores.result.maybeError
            ].compactMap { $0 }
            onFailure(errors: errors)
        }
    }
    
    private func onSuccess(schools: [SchoolModel], scores: [SATScoreModel]) {
        let mapping = SchoolMetaPair.makeMapping(schools: schools, scores: scores)
        receiver(.success(mapping))
    }
    
    private func onFailure(errors: [Error]) {
        receiver(.failure(.multiFetch(errors)))
    }
}

extension Result {
    var maybeError: Error? {
        do { _ = try get(); return nil }
        catch { return error }
    }
}
