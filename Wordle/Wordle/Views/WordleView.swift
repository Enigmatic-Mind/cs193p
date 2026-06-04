//
//  WordleView.swift
//  Wordle
//
//  Created by Francisco on 6/2/26.
//

import SwiftUI

struct WordleView: View {
    //MARK: - Data In
    @Environment(\.words) var words
    
    //MARK: - Data Owned by Me
    @State private var game = Wordle()
    
    @State private var selection: Int = 0
    @State private var restarting = false
    
    
    
    var body: some View {
        VStack {
            Button("Restart", systemImage: "arrow.circlepath", action: restart)
            WordView()
            ScrollView {
                if !game.isOver || restarting {
                    WordView()
                }
                
            }
        }
    }
    
    func restart() {
        
    }
}

#Preview {
    WordleView()
}
