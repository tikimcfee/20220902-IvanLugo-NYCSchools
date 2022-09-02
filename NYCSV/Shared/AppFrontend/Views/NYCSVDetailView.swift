//
//  NYCSVDetailView.swift
//  NYCSV
//
//  Created by Ivan Lugo on 9/1/22.
//

import SwiftUI

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
        VStack {
            headerView
            wideLine
            scoreView
            wideLine
            Spacer()
            
        }.padding(4)
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
    
    var wideLine: some View {
        Rectangle()
            .fill(.gray)
            .frame(width: .infinity, height: 1)
    }
}

extension NYCSVDetailView {
    @ViewBuilder
    func makeTextBlock(
        named blockName: String,
        from paths: [KeyPath<SchoolModel, String?>]
    ) -> some View {
        // A nicer way to do this is map the non-nil values first in the view state,
        // and only show non-empty sections.
        VStack {
            Text(blockName).bold()
            ForEach(Array(paths.enumerated()), id: \.offset) { index, path in
                if let fieldValue = state.metaPair.school[keyPath: path] {
                    Text(fieldValue)
                }
            }
        }
    }
    
    var programBlock: some View {
        makeTextBlock(named: "Programs", from: [
            \.program1,
             \.program2,
             \.program3
        ])
    }
    
    var opportunitiesBlock: some View {
        makeTextBlock(named: "Opportunities", from: [
            \.academicopportunities1,
             \.academicopportunities2,
             \.academicopportunities3,
        ])
    }
    
    var eligibilityBlock: some View {
        makeTextBlock(named: "Eligibility", from: [
            \.eligibility1,
             \.eligibility2,
             \.eligibility3,
        ])
    }
    
    var interestBlock: some View {
        makeTextBlock(named: "Interests", from: [
            \.interest1,
             \.interest2,
             \.interest3,
        ])
    }
    
    var priorityBlock: some View {
        makeTextBlock(named: "Admissions Priority", from: [
            \.admissionspriority11,
             \.admissionspriority12,
             \.admissionspriority13,
        ])
    }
    
    var directionsBlock: some View {
        makeTextBlock(named: "Directions", from: [
            \.directions1,
             \.directions2,
             \.directions3,
        ])
    }
    
    var extraBlocks: some View {
        makeTextBlock(named: "Extras", from: [
            \.school_accessibility_description,
             \.specialized,
             \.advancedplacement_courses,
             \.school_sports,
        ])
    }
    
    var contactBlock: some View {
        makeTextBlock(named: "Contact", from: [
            \.fax_number,
             \.community_board,
             \.school_email,
        ])
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
