//
//  WordBreaker.swift
//  Wordle
//
//  Created by Francisco on 6/4/26.
//

import Foundation

typealias Letter = String

struct WordBreaker {
    //MARK: - Data In    
    var masterCode: Word = Word(kind: .master(isHidden: false))
    var guess: Word = Word(kind: .guess)
    var attempts: [Word] = []
    
    init() {
        
    }
    
    var isOver: Bool {
        attempts.last?.letters == masterCode.letters
    }
    
    mutating func restart(word: String) {
        masterCode.kind = .master(isHidden: false)
        masterCode.word = word
        guess.reset()
        attempts.removeAll()
    }
    
    mutating func attemptGuess(isValid: Bool) {
        guard guess.letters.allSatisfy({ $0 != Word.missingLetter }),
              !attempts.contains(where: { $0.letters == guess.letters }),
              isValid else { return }
        
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.append(attempt)
        guess.reset()

        if isOver {
            masterCode.kind = .master(isHidden: false)
        }
    }
    
    mutating func setGuessLetter(_ letter: Letter, at index: Int) {
        guard guess.letters.indices.contains(index) else { return }
        guess.letters[index] = letter
    }
}
