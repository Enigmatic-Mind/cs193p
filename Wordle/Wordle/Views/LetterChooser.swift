//
//  WordChooser.swift
//  Wordle
//
//  Created by Francisco on 6/4/26.
//

import SwiftUI

struct LetterChooser: View {
    
    //MARK: - Data In
    let rows = [
        ["Q","W","E","R","T","Y","U","I","O","P"],
        ["A","S","D","F","G","H","J","K","L"],
        ["Z","X","C","V","B","N","M"]
    ]
    
    //MARK: - Data Out Function
    let onChoose: ((Letter) -> Void)?
    
    //MARK: - Body
    var body: some View {
        VStack {
            ForEach(rows, id: \.self) { row in
                HStack {
                    ForEach(row, id: \.self) { letter in
                        Button {
                            onChoose?(letter)
                        } label: {
                            LetterView(letter: letter)
                        }
                    }
                }
            }
        }
    }
}
