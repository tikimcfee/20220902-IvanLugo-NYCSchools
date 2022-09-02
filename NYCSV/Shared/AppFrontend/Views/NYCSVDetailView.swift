//
//  NYCSVDetailView.swift
//  NYCSV
//
//  Created by Ivan Lugo on 9/1/22.
//

import SwiftUI

class DetailViewState: ObservableObject {
    let metaPair: SchoolMetaPair
    
    init(metaPair: SchoolMetaPair) {
        self.metaPair = metaPair
    }
}

struct NYCSVDetailView: View {
    @ObservedObject var state: DetailViewState
    
    var body: some View {
        VStack {
            headerView
            Spacer()
        }.padding()
    }
    
    @ViewBuilder
    var headerView: some View {
        Text(state.metaPair.school.school_name)
            .font(.title)
        Rectangle()
            .fill(.gray)
            .frame(width: .infinity, height: 1)
    }
}

struct NYCSVDetailView_Previews: PreviewProvider {
    static let sample: SchoolMetaPair = {
        SampleData.sampleMetaList().first!
    }()
    
    static var previews: some View {
        NYCSVDetailView(
            state: DetailViewState(metaPair: sample)
        )
    }
}
