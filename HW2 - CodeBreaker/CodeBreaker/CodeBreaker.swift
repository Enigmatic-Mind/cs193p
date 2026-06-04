//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by Francisco on 5/20/26.
//

import Foundation

typealias Peg = String

struct CodeBreaker {
    var masterCode: Code = Code(kind: .master(isHidden: true))
    var guess: Code = Code(kind: .guess)
    var attempts: [Code] = []
    let pegCount: Int
    let pegChoices: [Peg]
    var themeTitle: String

    static let themes: [String: [Peg]] = [
        "Faces":    ["😀", "😎", "🥳", "😤", "🤔", "😴"],
        "Animals":  ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊"],
        "Vehicles": ["🚗", "🚕", "🚙", "🚌", "🚎", "🏎️"],
        "Classic":  ["red", "green", "blue", "yellow", "orange", "purple"],
    ]
        
    init(pegCount: Int = 4, theme: String = "Faces") {
        self.pegCount = pegCount
        self.themeTitle = theme
        self.pegChoices = CodeBreaker.themes[theme]!
        masterCode = Code(kind: .master(isHidden: true), pegCount: pegCount)
        guess = Code(kind: .guess, pegCount: pegCount)
        masterCode.randomize(from: pegChoices)
    }
    
    static func randomGame() -> CodeBreaker {
        let theme = themes.keys.randomElement()!
        return CodeBreaker(pegCount: Int.random(in: 3...6), theme: theme)
    }
    
    mutating func attemptGuess() {
        guard guess.pegs.allSatisfy({ $0 != Code.missingPeg }),
              !attempts.contains(where: { $0.pegs == guess.pegs }) else { return }
        
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.append(attempt)
    }
    
    mutating func changeGuessPeg(at index: Int) {
        let existingPeg = guess.pegs[index]
        if let indexOfExistingPegInPegChoices = pegChoices.firstIndex(of: existingPeg) {
            let newPeg = pegChoices[(indexOfExistingPegInPegChoices + 1) % pegChoices.count]
            guess.pegs[index] = newPeg
        } else {
            guess.pegs[index] = pegChoices.first ?? Code.missingPeg
        }
    }
}




