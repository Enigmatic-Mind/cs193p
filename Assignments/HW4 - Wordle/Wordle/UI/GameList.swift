//
//  GameList.swift
//  Wordle
//
//  Created by Francisco on 6/12/26.
//

import SwiftUI

struct GameList: View {
    //MARK: - Data In
    @Environment(\.words) var words
    
    //MARK: - Data Shared with Me
    @Binding var selection: WordBreaker?
    
    //MARK: - Data Owned by Me
    @State private var games: [WordBreaker] = []
    @State private var gameToEdit: WordBreaker?
    
    var body: some View {
        List(selection: $selection) {
            ForEach(games) { game in
                NavigationLink(value: game) {
                    GameSummary(game: game)
                }
                .contextMenu {
                    editButton(for: game) // editing a game
                    deleteButton(for: game)
                }
                .swipeActions(edge: .leading) {
                    editButton(for: game)
                        .tint(.accentColor)
                }
            }
            .onDelete { offsets in
                games.remove(atOffsets: offsets)
            }
            .onMove { offsets, destination in
                games.move(fromOffsets: offsets, toOffset: destination)
            }
        }
        .onChange(of: games) {
            if let selection, !games.contains(selection) {
                self.selection = nil
            }
        }
        .onChange(of: selection?.attempts) { oldValue, newValue in
            guard let selection else { return }
            guard let currentIndex = games.firstIndex(of: selection) else { return }
            
            let oldCount = oldValue?.count ?? 0
            let newCount = newValue?.count ?? 0
            guard newCount > oldCount else { return }
            
            withAnimation {
                games.move(fromOffsets: IndexSet(integer: currentIndex), toOffset: 0)
            }
        }
        .listStyle(.plain)
        .toolbar {
            addButton
            EditButton() // editing the List of games
        }
    }
    
    func editButton(for game: WordBreaker) -> some View {
        Button("Edit", systemImage: "pencil") {
            gameToEdit = game
        }
    }
    
    var addButton: some View {
        Button("Add Game", systemImage: "plus") {
            let masterCode = words.random(length: 5)
            let gameToEdit = WordBreaker(masterCode: masterCode ?? "AWAIT")
            games.insert(gameToEdit, at: 0)
        }
//        .sheet(isPresented: showGameEditor) {
//            gameEditor
//        }
    }
    
    func deleteButton(for game: WordBreaker) -> some View {
        Button("Delete", systemImage: "minus.circle", role: .destructive) {
            withAnimation {
                games.removeAll { $0 == game }
            }
        }
    }
}

#Preview {
    @Previewable @State var selection: WordBreaker?
    NavigationStack {
        GameList(selection: $selection)
    }
}
