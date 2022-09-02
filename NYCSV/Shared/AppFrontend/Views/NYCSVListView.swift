//
//  NYCSVListView.swift
//  NYCSV
//
//  Created by Ivan Lugo on 9/1/22.
//

import SwiftUI

class ListViewState: ObservableObject {
    var pairList: [SchoolMetaPair]
    
    @Published var selectedSchool: SchoolMetaPair?
    
    init(pairList: [SchoolMetaPair]) {
        self.pairList = pairList
    }
}

struct NYCSVListView: View {
    @ObservedObject var listState: ListViewState
    
    var body: some View {
        // The padding in this and subviews is used to keep the nice
        // underscroll effect of the home bar on iPhone X+, which helps
        // show off the above-the-fold hint there's more to scroll to.
        NavigationView {
            rootContainerView
                .navigationTitle("NYC Schools")
                .padding([.leading, .trailing], 20)
        }
    }
    
    var rootContainerView: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 8) {
                ForEach(listState.pairList) { metaPair in
                    NYCSVListViewCell(
                        schoolMetaPair: metaPair,
                        selectedSchool: $listState.selectedSchool
                    )
                    
                    NavigationLink(
                        tag: metaPair,
                        selection: $listState.selectedSchool,
                        destination: {
                            NYCSVDetailView(
                                state: DetailViewState(metaPair: metaPair)
                            )
                        }, label: { EmptyView() })
                }
            }.padding([.bottom], 64)
        }
    }
}

struct NYCSVListView_Previews: PreviewProvider {
    static let sample: [SchoolMetaPair] = {
        SampleData.sampleMetaList()
    }()
    
    static let testState: ListViewState = {
        ListViewState(pairList: sample)
    }()
    
    static var previews: some View {
        NYCSVListView(listState: testState)
    }
}
