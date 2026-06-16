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
    @State private var sortOption: GameList.SortOption = .all
    @State private var search: String = ""
    
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            Picker("Sort By", selection: $sortOption.animation(.default)) {
                ForEach(GameList.SortOption.allCases, id: \.self) { option in
                    Text(option.title)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            GameList(sortBy: sortOption, nameContains: search, selection: $selection)
            //GameList(selection: $selection)
                .navigationTitle("Wordle")
                .searchable(text: $search)
                .animation(.easeOut, value: search)
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

#Preview(traits: .swiftData) {
    GameChooser()
}
