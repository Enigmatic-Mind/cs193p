//
//  PegView.swift
//  CodeBreaker
//
//  Created by Francisco on 6/4/26.
//

import SwiftUI

struct PegView: View {
    //MARK: - Data In
    let value: Peg
    
    //MARK: - Body
    
    let pegShape = RoundedRectangle(cornerRadius: 10)
    
    var body: some View {
        if let color = Color(name: value) {
            pegShape
                .overlay {
                    if value == Code.missingPeg {
                        pegShape
                            .strokeBorder(Color.gray)
                    }
                }
                .contentShape(pegShape)
                .aspectRatio(1, contentMode: .fit)
                .foregroundStyle(color)
        } else {
            Circle()
                .fill(Color.clear)
                .contentShape(Circle())
                .overlay {
                    if value != Code.missingPeg {
                        Text(value)
                    } else {
                        pegShape
                            .strokeBorder(Color.gray)
                    }
                    
                }
                .font(.system(size: 120))
                .minimumScaleFactor(9/120)
        }
    }
}
