//
//  PegView.swift
//  CodeBreaker
//
//  Created by Francisco on 5/25/26.
//

import SwiftUI

struct PegView: View {
    //MARK: - Data In
    let peg: Peg
    
    //MARK: - Body
    
    let pegShape = Circle() // RoundedRectangle(cornerRadius: 10)
    
    var body: some View {
        pegShape
        .overlay {
            if peg == Code.missingPeg {
                pegShape
                    .strokeBorder(Color.gray)
            }
        }
        .contentShape(pegShape)
        .aspectRatio(1, contentMode: .fit)
        .foregroundStyle(peg)
    }
}

#Preview {
    PegView(peg: .blue)
        .padding()
}
