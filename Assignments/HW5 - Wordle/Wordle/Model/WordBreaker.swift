//
//  WordBreaker.swift
//  Wordle
//
//  Created by Francisco on 6/4/26.
//

import Foundation
import SwiftData

typealias Letter = String

@Model class WordBreaker {
    //MARK: - Data In
    var name: String
    @Relationship(deleteRule: .cascade) var masterCode: Word = Word(kind: .master(isHidden: true))
    @Relationship(deleteRule: .cascade) var guess: Word = Word(kind: .guess)
    @Relationship(deleteRule: .cascade) var _attempts: [Word] = []
    @Transient var startTime: Date?
    var endTime: Date?
    var elapsedTime: TimeInterval = 0
    var lastAttemptDate: Date? = Date.now
    var isOver: Bool = false
    
    var attempts: [Word] {
        get { _attempts.sorted { $0.timestamp > $1.timestamp } }
        set { _attempts = newValue }
    }
    
    init(name: String = "Wordle", masterCode: String) {
        self.name = name
        self.masterCode.word = masterCode
    }
    
    func updateElapsedTime() {
        pauseTimer()
        startTimer()
    }
    
    func startTimer() {
        if startTime == nil, !isOver {
            startTime = .now
            elapsedTime += 0.00001
        }
    }
    
    func pauseTimer() {
        if let startTime {
            elapsedTime += Date.now.timeIntervalSince(startTime)
        }
        startTime = nil
    }

    func restart(word: String) {
        masterCode.kind = .master(isHidden: true)
        masterCode.word = word
        guess.reset()
        attempts.removeAll()
        startTime = .now
        endTime = nil
        elapsedTime = 0
        isOver = false
    }
    
    func attemptGuess(isValid: Bool) {
        guard guess.letters.allSatisfy({ $0 != Word.missingLetter }),
              !attempts.contains(where: { $0.letters == guess.letters }),
              isValid else { return }
        
        let attempt = Word(kind: .attempt(guess.match(against: masterCode)), letters: guess.letters)
        
//        var attempt = guess
//        attempt.kind = .attempt(guess.match(against: masterCode))
//        attempts.append(attempt)
        
        attempts.insert(attempt, at: 0)
        lastAttemptDate = .now
        guess.reset()

        if attempts.first?.letters == masterCode.letters {
            isOver = true
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
