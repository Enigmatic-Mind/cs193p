//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by Francisco on 5/4/26.
//

import SwiftUI

struct CodeBreakerView: View {
    let game = CodeBreaker()
    
    var body: some View {
        VStack {
            view(for: game.masterCode)
            view(for: game.guess)
            //pegs(colors: game.attempts.pegs)
        }
        .padding()
    }
    
    //func pegs(colors: Array<Color>) -> some View {
    func view(for code: Code) -> some View {
        HStack {
            ForEach(code.pegs.indices, id: \.self) { index in
                RoundedRectangle(cornerRadius: 10)
                    .aspectRatio(1, contentMode: .fit)
                    .foregroundStyle(code.pegs[index])
                    .onTapGesture {
                        if code.kind == .guess {
                            game.changeGuessPeg(at: index)
                        }
                    }
            }
            MatchMarkers(matches: [.exact, .inexact, .noMatch, .exact])
            
        }
    }
}


#Preview {
    CodeBreakerView()
}
