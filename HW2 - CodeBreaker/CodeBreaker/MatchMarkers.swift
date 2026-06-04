//
//  MatchMarkers.swift
//  CodeBreaker
//
//  Created by Francisco on 5/4/26.
//

import SwiftUI

enum Match {
    case noMatch
    case exact
    case inexact
}

struct MatchMarkers: View {
    //MARK: - Data In
    var matches: [Match]
    
    //MARK: - Body
    var body: some View {
        let evenIndices = matches.indices
            .filter { $0 % 2 == 0 }
        
        HStack {
            ForEach(evenIndices, id: \.self) { index in
                VStack {
                    matchMarker(peg: index)
                    matchMarker(peg: index + 1)
                }
            }
        }
    }
    
    func matchMarker(peg: Int) -> some View {
        let exactCount = matches.count { $0 == .exact }
        let foundCount = matches.count { $0 != .noMatch }
        
        return Circle()
            .fill(exactCount > peg ? Color.primary : .clear)
            .strokeBorder(
                foundCount > peg ? Color.primary : .clear,
                lineWidth: 2
            )
            .aspectRatio(contentMode: .fit)
    }
}

struct MatchMarkersPreview: View {
    let matches: [Match]
    
    var body: some View {
        HStack {
            ForEach(matches.indices, id: \.self) { _ in
                Circle()
            }
            MatchMarkers(matches: matches)
        }
        .padding()

    }
}


#Preview {
    VStack(alignment: .leading) {
        MatchMarkersPreview(matches: [.exact, .noMatch, .noMatch])
        MatchMarkersPreview(matches: [.exact, .inexact, .exact, .exact])
        MatchMarkersPreview(matches: [.exact, .inexact, .exact, .exact, .inexact])
        MatchMarkersPreview(matches: [.exact, .inexact, .exact, .exact, .inexact, .noMatch])
        MatchMarkersPreview(matches: [.exact, .inexact, .exact, .exact, .inexact, .noMatch])
        MatchMarkersPreview(matches: [.exact, .inexact, .exact, .noMatch])
        MatchMarkersPreview(matches: [.exact, .inexact, .exact, .exact, .noMatch])
        MatchMarkersPreview(matches: [.exact, .inexact, .exact, .exact, .inexact, .noMatch])
        MatchMarkersPreview(matches: [.exact, .inexact, .exact, .exact, .inexact, .noMatch])
    }
}
