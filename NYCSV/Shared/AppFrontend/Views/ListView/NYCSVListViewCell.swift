//
//  NYCSVListViewCell.swift
//  NYCSV
//
//  Created by Ivan Lugo on 9/2/22.
//

import SwiftUI

// This cell actually knows about the list state that it comes from
// which is a minor breach of the dependency chain. Doing this greatly
// simplifies communication between the cell and its parent. Another
// pathway to this functionality is a CellState that has binding to
// said list state, which queries and updates selection / cell state.
class ListViewCellState: ObservableObject {
    @Published var isExpanded: Bool = false
    
    func shortSummary(_ pair: SchoolMetaPair) -> String {
        // Find first setence or first N characters.
        let text = pair.school.overview_paragraph
        let cutoff = 256
        if text.count > cutoff {
            let endIndex = text.index(text.startIndex, offsetBy: min(cutoff, text.count))
            let range = (text.startIndex..<endIndex)
            return String(text[range]) + "  [...]"
        } else {
            return text
        }
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

struct NYCSVListViewCell: View {
    let schoolMetaPair: SchoolMetaPair
    @Binding var selectedSchool: SchoolMetaPair?
    
    @StateObject private var cellState = ListViewCellState()
    
    var body: some View {
        schoolView(schoolMetaPair)
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
        .onTapGesture {
            withAnimation {
                cellState.isExpanded.toggle()
            }
        }
    }
    
    @ViewBuilder
    func headerView(_ metaPair: SchoolMetaPair) -> some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(metaPair.school.school_name).bold()
                Text(metaPair.school.city).fontWeight(.light).italic().font(.subheadline)
                websiteLinkView(metaPair.school).lineLimit(1).font(.subheadline)
            }
            // No need to show info button on macOS; it's handed by the navigation view.
            // A flag passed in from root? Sure, we could.
            #if os(iOS)
            Spacer()
            infoButtonView(metaPair)
            #endif
        }
    }
    
    @ViewBuilder
    func infoButtonView(_ metaPair: SchoolMetaPair) -> some View {
        Button(action: {
            print("Selected: \(metaPair.school.school_name)")
            selectedSchool = metaPair
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
        .buttonStyle(.plain)
        .foregroundColor(.accentColor)
    }
    
    @ViewBuilder
    func bodyView(_ metaPair: SchoolMetaPair) -> some View {
        if cellState.isExpanded {
            Text(metaPair.school.overview_paragraph)
                .lineLimit(nil)
                .frame(maxWidth: .infinity)
        } else {
            Text(cellState.shortSummary(metaPair))
                .fontWeight(.light)
                .italic()
                .lineLimit(nil)
                .frame(maxWidth: .infinity)
        }
    }
    
    @ViewBuilder
    func websiteLinkView(_ school: SchoolModel) -> some View {
        if let url = cellState.linkURL(for: school) {
            Link(destination: url) {
                Text(school.website).fontWeight(.light)
            }
        } else {
            Text(school.website).fontWeight(.light).italic()
        }
    }
}

struct NYCSVListViewCell_Previews: PreviewProvider {
    static let sample: [SchoolMetaPair] = {
        SampleData.sampleMetaList()
    }()
    
    static let testPair: SchoolMetaPair = {
        sample.first!
    }()
    
    static var selection: SchoolMetaPair?
    
    static var previews: some View {
        NYCSVListViewCell(
            schoolMetaPair: testPair,
            selectedSchool: Binding(
                get: { selection },
                set: { selection = $0 }
            )
        )
    }
}
