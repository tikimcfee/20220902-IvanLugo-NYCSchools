//
//  R.swift
//  NYCSV
//
//  Created by Ivan Lugo on 8/31/22.
//

import Foundation

import Combine

// We're pretending this is the top of an app-state hierarchy object.
// Ergo, we stuff a bunch of depedencies and global state into it.
// We'll whittle it down as we create subviews (e.g., the detail view)
class NYCSVAppState: ObservableObject {
    // The core load state. In a larger app, this would be a class
    // that hides the details of mapping domain data to load state.
    @Published var rootLoadState: LoadState = .launch
    
    private let networking = Networking()
    private var bag = Set<AnyCancellable>()
    
    init() {
        
    }
    
    func startRootLoad() {
        rootLoadState = .loading
        SchoolMetaFetcher(networking) { [weak self] result in
            switch result {
            case let .success(map):
                print("Received map with keys: \(map.keys.count)")
                self?.rootLoadState = .loaded(map.values.sorted(by: { $0 < $1 }))
                
            case let .failure(error):
                print("Fetch request failed")
                self?.rootLoadState = .error(error)
            }
        }.start()
    }
}

extension NYCSVAppState {
    enum LoadState {
        case launch
        
        case loading
        
        case loaded([SchoolMetaPair])
        
        case error(SchoolMetaFetcher.Failure)
    }
}
