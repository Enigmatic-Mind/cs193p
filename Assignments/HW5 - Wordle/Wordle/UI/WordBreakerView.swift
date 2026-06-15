//
//  WordBreakerView.swift
//  Wordle
//
//  Created by Francisco on 6/4/26.
//

import SwiftUI

struct WordBreakerView: View {
    
    //MARK: - Data Shared with Me
    let game: WordBreaker

    //MARK: - Data Owned by Me
    @State private var checker = UITextChecker()
    @State private var selection: Int = 0
    @State private var restarting = false
    
    var body: some View {
        VStack {
            WordView(word: game.masterCode) {
                Color.clear.aspectRatio(1, contentMode: .fit)
            }
            ScrollView {
                if !game.isOver || restarting {
                    WordView(word: game.guess, selection: $selection) {
                        Button("Guess", action: guess)
                            .flexibleSystemFont()
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
        .onAppear {
            print("\(game.masterCode)")
        }
    }
    
    func changePegAtSelection(to letter: Letter) {
        game.setGuessLetter(letter, at: selection)
        selection = (selection + 1) % game.masterCode.letters.count
    }
 
    func guess() {
        withAnimation(.guess) {
            game.attemptGuess(isValid: checker.isAWord(game.guess.word.lowercased()))
            selection = 0
        } completion: {
            withAnimation(.guess) {
            }
        }
    }
}

#Preview {
    @Previewable @State var game = WordBreaker(name: "Preview", masterCode: "AWAIT")
    NavigationStack {
        WordBreakerView(game: game)
    }
}
