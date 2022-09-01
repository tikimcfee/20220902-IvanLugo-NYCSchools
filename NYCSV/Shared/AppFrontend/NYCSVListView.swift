//
//  NYCSVListView.swift
//  NYCSV
//
//  Created by Ivan Lugo on 9/1/22.
//

import SwiftUI

class ListViewState: ObservableObject {
    var pairList: [SchoolMetaPair]
    
    init(pairList: [SchoolMetaPair]) {
        self.pairList = pairList
    }
    
    func linkURL(for school: SchoolModel) -> URL? {
        // Link() requires a fully qualified address; don't assume HTTPs,
        // not always available from school pages without redirect.
        let protocolFixup = school.website.starts(with: "http://")
            ? school.website
            : "http://\(school.website)"
        return URL(string: protocolFixup)
    }
}

struct NYCSVListView: View {
    @ObservedObject var listState: ListViewState
    
    var body: some View {
        rootContainerView
            .padding()
    }
    
    var rootContainerView: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(listState.pairList) { metaPair in
                    schoolView(metaPair)
                }
            }
        }
    }
    
    func schoolView(_ metaPair: SchoolMetaPair) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            headerView(metaPair)
            bodyView(metaPair)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 4.0)
                .strokeBorder(Color.gray)
        )
    }
    
    @ViewBuilder
    func headerView(_ metaPair: SchoolMetaPair) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(metaPair.school.school_name).bold()
                Text(metaPair.school.city).fontWeight(.light).italic().font(.subheadline)
                websiteLinkView(metaPair.school).lineLimit(1).font(.subheadline)
            }
            Spacer()
            Button(action: {
                // set detail param
                print("Selected: \(metaPair.school.school_name)")
            }) {
                Image(systemName: "info.circle.fill")
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 4.0)
                            .strokeBorder(Color.accentColor)
                    )
            }
        }
    }
    
    @ViewBuilder
    func bodyView(_ metaPair: SchoolMetaPair) -> some View {
        Text(metaPair.school.overview_paragraph).fontWeight(.light).padding(4)
    }
    
    @ViewBuilder
    func websiteLinkView(_ school: SchoolModel) -> some View {
        if let url = listState.linkURL(for: school) {
            Link(destination: url) {
                Text(school.website).fontWeight(.light)
            }
        } else {
            Text(school.website).fontWeight(.light).italic()
        }
    }
}

struct NYCSVListView_Previews: PreviewProvider {
    static let testState: ListViewState = {
        ListViewState(pairList: [
            .init(school: .init(
                dbn: "A",
                city: "New York City",
                zip: "01011",
                overview_paragraph: "It's a hip place to be",
                website: "www.nycyainahainalollerwatzerkatezer.com",
                school_name: "NYC High"
            ))
        ])
    }()
    
    static var previews: some View {
        NYCSVListView(listState: testState)
    }
}
