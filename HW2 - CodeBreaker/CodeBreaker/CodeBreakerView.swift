//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by Francisco on 5/4/26.
//

import SwiftUI

struct CodeBreakerView: View {
    @State var game = CodeBreaker.randomGame()
    
    var body: some View {
        VStack {
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
        .font(.system(size: 24))
        .minimumScaleFactor(0.1)
    }
    
    func view(for code: Code) -> some View {
        HStack {
            ForEach(code.pegs.indices, id: \.self) { index in
                PegView(gameType: game.gameType, value: code.pegs[index])
                    .onTapGesture {
                        if code.kind == .guess {
                            game.changeGuessPeg(at: index)
                        }
                    }
                    
            }
            
            Rectangle()
                .foregroundStyle(Color.clear)
                .aspectRatio(1, contentMode: .fit)
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

struct PegView: View {
    let gameType: CodeBreaker.GameType
    let value: String
    var body: some View {
        switch gameType {
        case .color:
            RoundedRectangle(cornerRadius: 10)
                .overlay {
                    if value == Code.missingPeg {
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(Color.gray)
                    }
                }
                .contentShape(Rectangle())
                .aspectRatio(1, contentMode: .fit)
                .foregroundStyle(Color.from(peg: value))
            
        case .emoji:
            Circle()
                .fill(Color.clear)
                .contentShape(Circle())
                .overlay {
                    if value != Code.missingPeg {
                        Text(value)
                    } else {
                        Circle()
                            .strokeBorder(Color.gray)
                    }
                    
                }
                .font(.system(size: 120))
                .minimumScaleFactor(9/120)
        }
    }
}


#Preview {
    CodeBreakerView()
}
