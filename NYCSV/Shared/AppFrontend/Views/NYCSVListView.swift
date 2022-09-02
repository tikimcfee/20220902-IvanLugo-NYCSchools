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
    @Published private var expandedSchools = [SchoolMetaPair: Bool]()
    
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
    
    func isExpanded(_ pair: SchoolMetaPair) -> Bool {
        expandedSchools[pair, default: false]
    }
    
    func metaPairTapped(_ pair: SchoolMetaPair) {
        expandedSchools[pair, default: false].toggle()
    }
    
    func shortSummary(_ pair: SchoolMetaPair) -> String {
        // Find first setence or first N characters.
        let text = pair.school.overview_paragraph
        let endIndex = text.firstIndex(of: ".")
            ?? text.index(text.startIndex, offsetBy: min(32, text.count))
        let range = (text.startIndex..<endIndex)
        return String(text[range]) + "  [...]"
    }
}

struct NYCSVListView: View {
    @ObservedObject var listState: ListViewState
    
    var body: some View {
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
                    schoolView(metaPair).onTapGesture {
                        withAnimation {
                            listState.metaPairTapped(metaPair)
                        }
                    }
                    
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
    
    func schoolView(_ metaPair: SchoolMetaPair) -> some View {
        VStack(alignment: .leading, spacing: 8) {
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
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(metaPair.school.school_name).bold()
                Text(metaPair.school.city).fontWeight(.light).italic().font(.subheadline)
                websiteLinkView(metaPair.school).lineLimit(1).font(.subheadline)
            }
            Spacer()
            Button(action: {
                print("Selected: \(metaPair.school.school_name)")
                listState.selectedSchool = metaPair
            }) {
                VStack {
                    Image(systemName: "info.circle.fill")
                    Text("Info").font(.caption2)
                }
                .padding([.leading, .trailing])
                .padding([.top, .bottom], 4)
                .background(
                    RoundedRectangle(cornerRadius: 4.0)
                        .strokeBorder(Color.accentColor)
                )
            }
        }
    }
    
    @ViewBuilder
    func bodyView(_ metaPair: SchoolMetaPair) -> some View {
        if listState.isExpanded(metaPair) {
            Text(metaPair.school.overview_paragraph)
        } else {
            Text(listState.shortSummary(metaPair))
                .fontWeight(.light)
                .italic()
        }
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
