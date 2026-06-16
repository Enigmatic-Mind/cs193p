//
//  GameSummary.swift
//  CodeBreaker
//
//  Created by CS193p Instructor on 4/30/25.
//

import SwiftUI

struct GameSummary: View {
    let game: WordBreaker
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(game.name).font(.title)
            WordView(word: game.attempts.first ?? game.guess)
                .frame(maxHeight: 50)
            Text("^[\(game.attempts.count) attempt](inflect: true)")
        }
    }
}

#Preview(traits: .swiftData) {
    List {
        GameSummary(game: WordBreaker(name: "Preview", masterCode: "AWAIT"))
    }
    List {
        GameSummary(game: WordBreaker(name: "Preview", masterCode: "AWAIT"))
    }
    .listStyle(.plain)
}

