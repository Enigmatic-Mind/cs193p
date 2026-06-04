//
//  Code.swift
//  CodeBreaker
//
//  Created by Francisco on 6/4/26.
//


import Foundation

struct Code {
    var kind: Kind
    var pegs: [Peg]
    
    static let missingPeg: Peg = "clear"
    
    enum Kind: Equatable {
        case master(isHidden: Bool)
        case guess
        case attempt([Match])
        case unknown
    }
    
    init(kind: Kind, pegCount: Int = 4) {
        self.kind = kind
        self.pegs = Array(repeating: Code.missingPeg, count: pegCount)
    }
    
    mutating func randomize(from pegChoices: [Peg]) {
        for index in pegs.indices {
            pegs[index] = pegChoices.randomElement() ?? Code.missingPeg
        }
    }
    
    var isHidden: Bool {
        switch kind {
        case .master(let isHidden): return isHidden
        default: return false
        }
    }
    
    mutating func reset() {
        pegs = Array(repeating: Code.missingPeg, count: pegs.count)
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
