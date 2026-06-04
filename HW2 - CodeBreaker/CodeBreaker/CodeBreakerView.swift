//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by Francisco on 5/4/26.
//

import SwiftUI

struct CodeBreakerView: View {
    //MARK: - Data Owned by Me
    @State private var game = CodeBreaker.randomGame()
    @State private var selection: Int = 0
    
    //MARK: - Body
    var body: some View {
        VStack {
            Text(game.themeTitle)
                .font(.system(size: 28, weight: .bold))
            view(for: game.masterCode)
            ScrollView {
                view(for: game.guess)
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    view(for: game.attempts[index])
                }
            }
            HStack {
                restartButton
            }
        }
        .padding()
    }
    
    var guessButton: some View {
        Button {
            withAnimation {
                game.attemptGuess()
            }
        } label: {
            Text("Guess")
        }
        .font(.system(size: 80))
        .minimumScaleFactor(0.1)
    }
    
    var restartButton: some View {
        Button {
            withAnimation {
                game = CodeBreaker.randomGame()
            }
        } label: {
            Text("Restart Game")
        }
        .font(.system(size: 18))
        .minimumScaleFactor(0.1)
    }
    
    func view(for code: Code) -> some View {
        HStack {
//            ForEach(code.pegs.indices, id: \.self) { index in
//                PegView(value: code.pegs[index])
//                    .onTapGesture {
//                        if code.kind == .guess {
//                            game.changeGuessPeg(at: index)
//                        }
//                    }
//                    
//            }
            
            CodeView(code: code, selection: $selection)
            
            Color.clear.aspectRatio(1, contentMode: .fit)
                .overlay {
                    if let matches = code.matches {
                        MatchMarkers(matches: matches)
                    } else {
                        if code.kind == .guess {
                            guessButton
                        }
                    }
                }
        }
    }
}




#Preview {
    CodeBreakerView()
}
