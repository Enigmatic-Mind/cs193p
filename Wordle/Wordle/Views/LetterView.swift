//
//  LetterView.swift
//  Wordle
//
//  Created by Francisco on 6/4/26.
//

import SwiftUI

struct LetterView: View {
    //MARK: - Data In
    let letter: Letter
    
    //MARK: - Body
    
    let letterShape = RoundedRectangle(cornerRadius: 10)
    
    var body: some View {
        letterShape
            .stroke()
            .overlay {
                if letter != Word.missingLetter {
                    Text(letter)
                } else {
                    letterShape
                }
            }
            .contentShape(letterShape)
            .aspectRatio(1, contentMode: .fit)
    }
}

//#Preview {
//    LetterView()
//}
