//
//  NYCSVDetailView.swift
//  NYCSV
//
//  Created by Ivan Lugo on 9/1/22.
//

import SwiftUI

extension DetailViewState {
    typealias BlocksList = [(String, [KeyPath<SchoolModel, String?>])]
    
    var blockSections: BlocksList {[
        ("Programs", from: [\.program1,\.program2,\.program3,]),
        ("Opportunities", from: [\.academicopportunities1,\.academicopportunities2,\.academicopportunities3,]),
        ("Eligibility", from: [\.eligibility1,\.eligibility2,\.eligibility3,]),
        ("Interests", from: [\.interest1,\.interest2,\.interest3,]),
        ("Admissions Priority", from: [\.admissionspriority11,\.admissionspriority12,\.admissionspriority13,]),
        ("Directions", from: [\.directions1,\.directions2,\.directions3,]),
        ("Extras", from: [\.school_accessibility_description,\.specialized,\.advancedplacement_courses,\.school_sports,]),
        ("Contact", from: [\.fax_number,\.community_board,\.school_email,])
    ];} // Found a compiler bug! Semicolon helps it disambiguate big list above.
}

class DetailViewState: ObservableObject {
    let metaPair: SchoolMetaPair
    var scores: SATScoreModel? { metaPair.scores }
    
    
    
    init(metaPair: SchoolMetaPair) {
        self.metaPair = metaPair
    }
    
    var mathScore: String { scores?.sat_math_avg_score ?? "~" }
    var readingScore: String { scores?.sat_critical_reading_avg_score ?? "~" }
    var writingScore: String { scores?.sat_writing_avg_score ?? "~" }
    
    var mathDisplayable: Bool { scoreIsDisplayable(mathScore) }
    var readingDisplayable: Bool { scoreIsDisplayable(readingScore) }
    var writingDisplayable: Bool { scoreIsDisplayable(writingScore) }
    
    private func scoreIsDisplayable(_ score: String?) -> Bool {
        score.map { Int($0) } != nil
    }
}

struct NYCSVDetailView: View {
    @ObservedObject var state: DetailViewState
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                headerView
                wideLine
                scoreView
                wideLine
                extraDetailsView
                wideLine
            }.padding([.bottom], 64)
        }
        .padding([.leading, .trailing], 20)
    }
    
    @ViewBuilder
    var headerView: some View {
        Text(state.metaPair.school.school_name)
            .font(.title)
    }
    
    @ViewBuilder
    var scoreView: some View {
        if let _ = state.metaPair.scores {
            VStack(spacing: 0) {
                Text("School SAT Averages")
                    .font(.title2)
                HStack {
                    scoreBox("Math", score: state.mathScore, valid: state.mathDisplayable)
                    scoreBox("Reading", score: state.mathScore, valid: state.readingDisplayable)
                    scoreBox("Writing", score: state.mathScore, valid: state.writingDisplayable)
                }
            }
        } else {
            Text("No SAT scores available")
        }
    }
    
    @ViewBuilder
    var extraDetailsView: some View {
        VStack(alignment: .leading) {
            ForEach(Array(state.blockSections.enumerated()), id: \.offset) { index, section in
                makeTextBlock(named: section.0, from: section.1)
                    .padding(4)
            }
        }.frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    func scoreBox(_ name: String, score: String, valid: Bool) -> some View {
        VStack(spacing: 2) {
            Text(name)
                .font(.title3)
                .underline()
            if valid {
                Text(score)
            } else {
                Text(score).italic().fontWeight(.light)
            }
        }.padding(8)
    }
    
    @ViewBuilder
    func makeTextBlock(
        named blockName: String,
        from paths: [KeyPath<SchoolModel, String?>]
    ) -> some View {
        // A nicer way to do this is map the non-nil values first in the view state,
        // and only show non-empty sections.
        VStack(alignment: .leading, spacing: 4) {
            Text(blockName).bold()
            ForEach(Array(paths.enumerated()), id: \.offset) { index, path in
                if let fieldValue = state.metaPair.school[keyPath: path] {
                    HStack(alignment: .firstTextBaseline) {
                        Text("‣")
                        Text(fieldValue)
                    }
                }
            }
        }
    }
    
    var wideLine: some View {
        Rectangle()
            .fill(.gray)
            .frame(maxWidth: .infinity, maxHeight: 1)
            .padding([.leading, .trailing], 32)
            .padding([.top, .bottom], 8)
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
