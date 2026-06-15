//
//  GameChooser.swift
//  Wordle
//
//  Created by Francisco on 6/12/26.
//

import SwiftUI

struct GameChooser: View {
    //MARK: - Data Owned by Me
    
    @State private var selection: WordBreaker? = nil
    
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            GameList(selection: $selection)
                .navigationTitle("Wordle")
        } detail: {
            if let selection {
                WordBreakerView(game: selection)
                    .navigationTitle(selection.name)
                    .navigationBarTitleDisplayMode(.inline)
            } else {
                Text("Choose a game!")
            }
        }
        .navigationSplitViewStyle(.balanced)
    }
}

#Preview {
    GameChooser()
}
