//
//  WordBreakerView.swift
//  Wordle
//
//  Created by Francisco on 6/4/26.
//

import SwiftUI

struct WordBreakerView: View {
    //MARK: - Data In
    @Environment(\.words) var words
    
    //MARK: - Data Owned by Me
    @State private var game = WordBreaker()
    @State private var checker = UITextChecker()
    @State private var selection: Int = 0
    @State private var restarting = false
    @State private var hideMostRecentMarkers = false
    
    var body: some View {
        VStack {
            Button("Restart", systemImage: "arrow.circlepath", action: restart)
            WordView(word: game.masterCode) {
                Color.clear.aspectRatio(1, contentMode: .fit)
            }
            ScrollView {
                if !game.isOver || restarting {
                    WordView(word: game.guess, selection: $selection) {
                        Button("Guess", action: guess).flexibleSystemFont()
                    }
                    .animation(nil, value: game.attempts.count)
                    .opacity(restarting ? 0 : 1)
                }
                
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    WordView(word: game.attempts[index]) {
                        
                    }
                    .transition(.attempt(game.isOver))
                    
                }
            }
            
            if !game.isOver {
                LetterChooser(onChoose: changePegAtSelection)
                .aspectRatio(10/3, contentMode: .fit)
            }
            
        }
        .padding()
        .onChange(of: words.count, initial: true) {
            if game.attempts.count == 0 {
                game.masterCode.word = "AWAIT"
            } else {
                game.masterCode.word = words.random(length: 5) ?? "ERROR"
            }
        }
    }
    
    func changePegAtSelection(to letter: Letter) {
        game.setGuessLetter(letter, at: selection)
        selection = (selection + 1) % game.masterCode.letters.count
    }
    
    func restart() {
        withAnimation(.restart) {
            restarting = true
        } completion: {
            withAnimation(.restart) {
                game.restart(word: words.random(length: 5) ?? "ERROR")
                selection = 0
                restarting = false
            }
        }
    }
    
    func guess() {
        withAnimation(.guess) {
            game.attemptGuess(isValid: checker.isAWord(game.guess.word.lowercased()))
            selection = 0
            hideMostRecentMarkers = true
        } completion: {
            withAnimation(.guess) {
                hideMostRecentMarkers = false
            }
        }
    }
}

#Preview {
    WordBreakerView()
}
