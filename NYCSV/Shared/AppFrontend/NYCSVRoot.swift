//
//  NYCSVRoot.swift
//  NYCSV
//
//  Created by Ivan Lugo on 8/31/22.
//

import SwiftUI

extension NYCSVAppState {
    enum LoadState {
        case launch
        case loading
        case loaded(SchoolMetaMap)
        case error(SchoolMetaFetcher.Failure)
    }
}

// We're pretending this is the top of an app-state hierarchy object.
// Ergo, we stuff a bunch of depedencies and global state into it.
// We'll whittle it down as we create subviews (e.g., the detail view)
class NYCSVAppState: ObservableObject {
    @Published var loadState: LoadState = .launch
    private let networking = Networking()
    
    func viewDidAppear() {
        loadState = .loading
        SchoolMetaFetcher(networking) { [weak self] result in
            switch result {
            case let .success(map):
                print("Received map with keys: \(map.keys.count)")
                self?.loadState = .loaded(map)
                
            case let .failure(error):
                self?.loadState = .error(error)
            }
        }.start()
    }
}

struct NYCSVRoot: View {
    @EnvironmentObject var appState: NYCSVAppState
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    
    @ViewBuilder
    func buildViewForState() -> some View {
        switch appState.loadState {
        case .launch: launchView
        case .loading: loadingView
        case let .loaded(map): loadedView(map)
        case let .error(failure): errorView(failure)
        }
    }
    
    var launchView: some View {
        Text("📚 We're getting ready, just a moment")
            .padding(64)
    }
    
    var loadingView: some View {
        ProgressView("🎓 Grabbing NYC Schools and SAT Scores")
            .padding(64)
    }
    
    func loadedView(_ map: SchoolMetaMap) -> some View {
        EmptyView()
    }
    
    func errorView(_ failure: SchoolMetaFetcher.Failure) -> some View {
        EmptyView()
    }
}

struct NYCSVRoot_Previews: PreviewProvider {
    static var previews: some View {
        NYCSVRoot()
    }
}
