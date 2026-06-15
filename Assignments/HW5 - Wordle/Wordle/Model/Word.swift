//
//  Word.swift
//  Wordle
//
//  Created by Francisco on 6/4/26.
//

import Foundation

enum Match {
    case noMatch
    case exact
    case inexact
}

struct Word: Equatable {
    var kind: Kind
    var letters: [Letter]
    
    static let missingLetter: Letter = ""
    
    var word: String {
        get { letters.joined() }
        set { letters = newValue.map { String($0) } }
    }

    
    enum Kind: Equatable {
        case master(isHidden: Bool)
        case guess
        case attempt([Match])
        case unknown
    }
    
    init(kind: Kind, letterCount: Int = 5) {
        self.kind = kind
        self.letters = Array(repeating: Word.missingLetter, count: letterCount)
    }
    
    var isHidden: Bool {
        switch kind {
        case .master(let isHidden): return isHidden
        default: return false
        }
    }
    
    mutating func reset() {
        letters = Array(repeating: Word.missingLetter, count: letters.count)
    }
    
    var matches: [Match]? {
        switch kind {
        case .attempt(let matches): return matches
        default: return nil
        }
    }
    
    func match(against otherWord: Word) -> [Match] {
        var lettersToMatch = otherWord.letters
        
        let backwardExactMatches = letters.indices.reversed().map { index in
            if lettersToMatch.count > index, lettersToMatch[index] == letters[index] {
                lettersToMatch.remove(at: index)
                return Match.exact
            } else {
                return .noMatch
            }
        }
        
        let exactMatches = Array(backwardExactMatches.reversed())
        return letters.indices.map { index in
            if exactMatches[index] != .exact, let matchIndex = lettersToMatch.firstIndex(of: letters[index]) {
                lettersToMatch.remove(at: matchIndex)
                return .inexact
            } else {
                return exactMatches[index]
            }
        }
    }
}
