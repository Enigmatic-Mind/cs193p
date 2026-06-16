//
//  Word.swift
//  Wordle
//
//  Created by Francisco on 6/4/26.
//

import Foundation
import SwiftData

@Model class Word {
    var _kind: String = Kind.unknown.description
    //var letters: [Letter]
    var _letters: String = ""
    var timestamp = Date.now
    
    var kind: Kind {
        get { return Kind(_kind) }
        set { _kind = newValue.description }
    }
    
    var letters: [Letter] {
        get { _letters.map{ String($0) } }
        set { _letters = newValue.joined() }
    }
    
    init(kind: Kind, letterCount: Int = 5) {
        self._letters = String(repeating: " ", count: letterCount)
        self.kind = kind
    }
    
    init(kind: Kind, letters: [Letter]) {
        self._letters = letters.joined()
        self.kind = kind
    }
    
    static let missingLetter: Letter = " "
    
    var word: String {
        get { _letters }
        set { _letters = newValue }
    }
    
    var isHidden: Bool {
        switch kind {
        case .master(let isHidden): return isHidden
        default: return false
        }
    }
    
    func reset() {
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

enum Match: String {
    case noMatch
    case exact
    case inexact
}
