//
//  LetterView.swift
//  Wordle
//
//  Created by Francisco on 6/2/26.
//

import SwiftUI

struct LetterView: View {
    //MARK: - Data In
    let peg: Peg
    
    //MARK: - Body
    
    let pegShape = RoundedRectangle(cornerRadius: 10)
    
    var body: some View {
        pegShape
            .contentShape(pegShape)
            .aspectRatio(1, contentMode: .fit)
            .stroke()
    }
}
