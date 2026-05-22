//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by Francisco on 5/20/26.
//

import SwiftUI

typealias Peg = Color

struct CodeBreaker {
    var masterCode: Code = Code(kind: .master)
    var guess: Code = Code(kind: .guess)
    var attempts: [Code] = []
    let pegChoices: [Peg]
    
    init(pegChoices: [Peg] = [.red, .green, .blue, .yellow]) {
        self.pegChoices = pegChoices
        masterCode.randomize(from: pegChoices)
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

struct Code {
    var kind: Kind
    var pegs: [Peg] = Array(repeating: Code.missingPeg, count: 4)
    
    static let missingPeg: Peg = .clear
    
    enum Kind: Equatable {
        case master
        case guess
        case attempt([Match])
        case unknown
    }
    
    mutating func randomize(from pegChoices: [Peg]) {
        for index in pegChoices.indices {
            pegs[index] = pegChoices.randomElement() ?? Code.missingPeg
        }
    }
    
    var matches: [Match]? {
        switch kind {
        case .attempt(let matches): return matches
        default: return nil
        }
    }
    
    // TODO: Review
    //    func match(against otherCode: Code) -> [Match] {
    //        var results: [Match] = Array(repeating: .noMatch, count: pegs.count)
    //        var pegsToMatch = otherCode.pegs
    //        for index in pegs.indices.reversed() {
    //            if pegsToMatch.count > index, pegsToMatch[index] == pegs[index] {
    //                results[index] = .exact
    //                pegsToMatch.remove(at: index)
    //            }
    //        }
    //
    //        for index in pegs.indices {
    //            if results[index] != .exact {
    //                if let matchIndex = pegsToMatch.firstIndex(of: pegs[index]) {
    //                    results[index] = .inexact
    //                    pegsToMatch.remove(at: matchIndex)
    //                }
    //            }
    //        }
    //        return results
    //    }
    
    // TODO: understand
    func match(against otherCode: Code) -> [Match] {
        var pegsToMatch = otherCode.pegs
        
        let backwardExactMatches = pegs.indices.reversed().map { index in
            if pegsToMatch.count > index, pegsToMatch[index] == pegs[index] {
                pegsToMatch.remove(at: index)
                return Match.exact
            } else {
                return .noMatch
            }
        }
        
        let exactMatches = Array(backwardExactMatches.reversed())
        return pegs.indices.map { index in
            if exactMatches[index] != .exact, let matchIndex = pegsToMatch.firstIndex(of: pegs[index]) {
                pegsToMatch.remove(at: matchIndex)
                return .inexact
            } else {
                return exactMatches[index]
            }
        }
        
    }
}


