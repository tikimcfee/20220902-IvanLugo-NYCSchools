//
//  NYCSVRoot.swift
//  NYCSV
//
//  Created by Ivan Lugo on 8/31/22.
//

import SwiftUI

struct NYCSVRoot: View {
    @EnvironmentObject var appState: NYCSVAppState
    
    var body: some View {
        buildViewForState()
        #if os(macOS)
            .frame(minWidth: 640, maxWidth: 1024)
        #endif
    }
    
    @ViewBuilder
    func buildViewForState() -> some View {
        switch appState.rootLoadState {
        case .launch: launchView
        case .loading: loadingView
        case let .loaded(sortedList): loadedView(sortedList)
        case let .error(failure): errorView(failure)
        }
    }
    
    var launchView: some View {
        Text("📚 We're getting ready, just a moment.")
            .padding(64)
    }
    
    var loadingView: some View {
        ProgressView(label: {
            Text("🎓 Grabbing NYC Schools and SAT Scores.")
                .multilineTextAlignment(.center)
        }).padding(64)
    }
    
    func loadedView(_ pairList: [SchoolMetaPair]) -> some View {
        // If appState changes often we'd want to reuse a view state instance.
        // It's quite easy to get tripped up with rebuilds in SUI, especially
        // with top level observables / environment objects.
        NYCSVListView(listState: ListViewState(pairList: pairList))
    }
    
    func errorView(_ failure: SchoolMetaFetcher.Failure) -> some View {
        VStack {
            Text("😢 Something seems to have gone wrong. Here's what we know:")
                .multilineTextAlignment(.center)
                .padding(64)
            VStack(alignment: .leading) {
                switch failure {
                case let .multiFetch(errors):
                    ForEach(Array(errors.enumerated()), id:\.offset) { index, error in
                        Text(error.localizedDescription)
                    }
                }
            }
        }
    }
}

struct NYCSVRoot_Previews: PreviewProvider {
    static var previews: some View {
        NYCSVRoot()
            .environmentObject(NYCSVAppState())
    }
}
