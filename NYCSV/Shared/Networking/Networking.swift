//
//  Networking.swift
//  NYCSV
//
//  Created by Ivan Lugo on 8/31/22.
//

import Foundation

typealias URLSessionCompletion = (Data?, URLResponse?, Error?) -> Void

enum NetworkError: Error {
    case missingData
}

// The generics here are a little gimmicky, but for the simple calls so far, it's fine.
// I'll tack on more fetch methods for different parsing schemes.
class Networking {
    private let urlSession = URLSession.shared
    private let backgroundQueue = DispatchQueue.init(label: "NetworkQueue", qos: .userInitiated)
    
    func doFetch<T>(_ request: ListFetch<T>.Request, _ receiver: @escaping ListFetch<T>.Receiver) {
        print(">>> Equeuing fetch: \(request.endpoint)")
        fetch(request.endpoint) { data, _, error in
            let response: ListFetch<T>.Response
            defer { receiver(response) }
            
            print("<< Fetch responded: \(request.endpoint)")
            do {
                guard let data = data else { throw NetworkError.missingData }
                let result = try T.decodeAsList(from: data)
                response = ListFetch<T>.Response(request: request, result: .success(result))
            } catch {
                print(error)
                response = ListFetch<T>.Response(request: request, result: .failure(error))
            }
        }
    }
    
    private func fetch(_ url: URL, _ callback: @escaping URLSessionCompletion) {
        backgroundQueue.async { [weak self] in
            print(">> Starting fetch: \(url)")
            self?.urlSession.dataTask(with: url, completionHandler: callback).resume()
        }
    }
}

// A little cheat code for parsing. We can play with generics more
// if we have other decodable types, and wrap them in similar models.
struct ListFetch<Model: ListDecodable> {
    private init() { }
    
    typealias Receiver = (Response) -> Void
    
    struct Request {
        let endpoint: URL
    }
    
    struct Response {
        let request: Request
        let result: Result<[Model], Error>
    }

    static func attemptParse(from data: Data) throws -> [Model] {
        try Model.decodeAsList(from: data)
    }
}
