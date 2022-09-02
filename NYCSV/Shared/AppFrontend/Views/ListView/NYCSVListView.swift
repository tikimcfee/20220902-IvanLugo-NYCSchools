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
            rootContainerView.navigationTitle("NYC Schools")
        }
    }
    
    // This is one of the more crufty parts of early SwiftUI. Because a
    // of the iOS / macOS internal representations are based on UIKit / AppKit,
    // each platform has different quirks with how you need to use things like
    // nav views and lists. E.g., navigation works just fine in iOS when using
    // 'invisible' navitation links, but not in macOS. It's just a quirk, easy
    // enough to work around with a conditional compilation. A new view for each
    // OS? Yeah, probably, but hey, it's a sample app right? 
    #if os(macOS)
    var rootContainerView: some View {
        List {
            ForEach(listState.pairList) { metaPair in
                NavigationLink(
                    tag: metaPair,
                    selection: $listState.selectedSchool,
                    destination: {
                        NYCSVDetailView(
                            state: DetailViewState(metaPair: metaPair)
                        )
                    },
                    label: {
                        NYCSVListViewCell(
                            schoolMetaPair: metaPair,
                            selectedSchool: $listState.selectedSchool
                        )
                    })
            }
        }
    }
    #else
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
        }.padding([.leading, .trailing], 20)
    }
    #endif
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
