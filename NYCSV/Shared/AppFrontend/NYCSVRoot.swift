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
        Text("📚 We're getting ready, just a moment")
            .padding(64)
    }
    
    var loadingView: some View {
        ProgressView("🎓 Grabbing NYC Schools and SAT Scores")
            .padding(64)
    }
    
    func loadedView(_ pairList: [SchoolMetaPair]) -> some View {
        List {
            ForEach(pairList) { metaPair in
                VStack {
                    HStack {
                        Text("Name: ")
                        Spacer()
                        Text(metaPair.school.school_name)
                    }
                    Text(metaPair.school.city).fontWeight(.light)
                    Text(metaPair.school.website).fontWeight(.light)
                    Text(metaPair.school.overview_paragraph).fontWeight(.light).padding(4)
                }
            }
        }.listStyle(.plain)
    }
    
    func errorView(_ failure: SchoolMetaFetcher.Failure) -> some View {
        EmptyView()
    }
}

struct NYCSVRoot_Previews: PreviewProvider {
    static var previews: some View {
        NYCSVRoot()
            .environmentObject(NYCSVAppState())
    }
}
