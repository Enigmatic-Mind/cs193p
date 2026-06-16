//
//  GameList.swift
//  Wordle
//
//  Created by Francisco on 6/12/26.
//

import SwiftUI
import SwiftData

struct GameList: View {
    //MARK: - Data In
    @Environment(\.words) var words
    @Environment(\.modelContext) var modelContext
    
    //MARK: - Data Shared with Me
    @Binding var selection: WordBreaker?
    @Query private var games: [WordBreaker]
    
    //MARK: - Data Owned by Me
    //@State private var games: [WordBreaker] = []
    @State private var gameToEdit: WordBreaker?
    @State private var showSettings: Bool = false
    let search: String
    var filteredGames: [WordBreaker] {
        games.filter { game in
            guard !search.isEmpty else { return true }
            
            let matchesName = game.name.lowercased().contains(search.lowercased())
            let matchesAttempt = game.attempts.contains { $0.word.lowercased().contains(search.lowercased()) }
            let matchesMaster = game.isOver && game.masterCode.word.lowercased().contains(search.lowercased())
            
            return matchesName || matchesAttempt || matchesMaster
        }
    }
    
    
    init(sortBy: SortOption = .all, nameContains search: String = "", selection: Binding<WordBreaker?>) {
        _selection = selection
        self.search = search
        let completedOnly = sortBy == .completed
        let predicate = #Predicate<WordBreaker> { game in
            (!completedOnly || game.isOver)
        }
        switch sortBy {
        case .all: _games = Query(filter: predicate, sort: \WordBreaker.lastAttemptDate, order: .reverse)
        case .completed: _games = Query(filter: predicate, sort: \WordBreaker.lastAttemptDate, order: .reverse)
        }
    }
    
    enum SortOption: CaseIterable {
        case all
        case completed
        
        var title: String {
            switch self {
            case .all: "All"
            case .completed: "Completed"
            }
        }
    }
    
    var body: some View {
        List(selection: $selection) {
            ForEach(filteredGames) { game in
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
                //games.remove(atOffsets: offsets)
                for offset in offsets {
                    modelContext.delete(filteredGames[offset])
                }
            }
        }
        .onChange(of: games) {
            if let selection, !games.contains(selection) {
                self.selection = nil
            }
        }
        .listStyle(.plain)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                settingsButton
            }
            ToolbarItem(placement: .primaryAction) {
                addButton
            }
            ToolbarItem(placement: .secondaryAction) {
                EditButton()
            }
        }
    }
    
    func editButton(for game: WordBreaker) -> some View {
        Button("Edit", systemImage: "pencil") {
            gameToEdit = game
        }
    }
    
    var addButton: some View {
        Button("Add Game", systemImage: "plus") {
            let masterCode = words.random(length: SettingsViewModel.shared.wordLength)
            let gameToEdit = WordBreaker(masterCode: masterCode ?? "AWAIT")
            //games.insert(gameToEdit, at: 0)
            modelContext.insert(gameToEdit)
        }
//        .sheet(isPresented: showGameEditor) {
//            gameEditor
//        }
    }
    
    var settingsButton: some View {
        Button("Settings", systemImage: "gear") {
            showSettings = true
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
    
    func deleteButton(for game: WordBreaker) -> some View {
        Button("Delete", systemImage: "minus.circle", role: .destructive) {
            withAnimation {
                //games.removeAll { $0 == game }
                modelContext.delete(game)
            }
        }
    }
}

#Preview(traits: .swiftData) {
    @Previewable @State var selection: WordBreaker?
    NavigationStack {
        GameList(selection: $selection)
    }
}
