//
//  WordBreaker.swift
//  Wordle
//
//  Created by Francisco on 6/4/26.
//

import Foundation

typealias Letter = String

@Observable
class WordBreaker {
    //MARK: - Data In
    var name: String
    var masterCode: Word = Word(kind: .master(isHidden: true))
    var guess: Word = Word(kind: .guess)
    var attempts: [Word] = []
    var startTime: Date?
    var endTime: Date?
    var elapsedTime: TimeInterval = 0
    
    init(name: String = "Wordle", masterCode: String) {
        self.name = name
        self.masterCode.word = masterCode
    }
    
    func startTimer() {
        if startTime == nil, !isOver {
            startTime = .now
        }
    }
    
    func pauseTimer() {
        if let startTime {
            elapsedTime += Date.now.timeIntervalSince(startTime)
        }
        startTime = nil
    }
    
    var isOver: Bool {
        attempts.last?.letters == masterCode.letters
    }
    
    func restart(word: String) {
        masterCode.kind = .master(isHidden: true)
        masterCode.word = word
        guess.reset()
        attempts.removeAll()
        startTime = .now
        endTime = nil
        elapsedTime = 0
    }
    
    func attemptGuess(isValid: Bool) {
        guard guess.letters.allSatisfy({ $0 != Word.missingLetter }),
              !attempts.contains(where: { $0.letters == guess.letters }),
              isValid else { return }
        
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.append(attempt)
        guess.reset()

        if isOver {
            endTime = .now
            masterCode.kind = .master(isHidden: false)
            pauseTimer()
        }
    }
    
    func setGuessLetter(_ letter: Letter, at index: Int) {
        guard guess.letters.indices.contains(index) else { return }
        guess.letters[index] = letter
    }
}

extension WordBreaker: Identifiable, Hashable, Equatable {
    static func == (lhs: WordBreaker, rhs: WordBreaker) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
