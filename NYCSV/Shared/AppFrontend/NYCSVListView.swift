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
}

struct NYCSVListView: View {
    @ObservedObject var listState: ListViewState
    
    var body: some View {
        List {
            ForEach(listState.pairList) { metaPair in
                VStack(alignment: .leading) {
                    Text(metaPair.school.school_name).bold()
                    Text(metaPair.school.city).fontWeight(.light).italic()
                    Text(metaPair.school.website).fontWeight(.light).italic()
                    Text(metaPair.school.overview_paragraph).fontWeight(.light).padding(4)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 4.0)
                        .strokeBorder(Color.gray)
                )
            }
        }.listStyle(.plain)
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
                website: "www.nyc.com",
                school_name: "NYC High"
            ))
        ])
    }()
    
    static var previews: some View {
        NYCSVListView(listState: testState)
    }
}
