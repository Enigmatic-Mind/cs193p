//
//  WordView.swift
//  Wordle
//
//  Created by Francisco on 6/4/26.
//

import SwiftUI

struct WordView<AncillaryView>: View where AncillaryView: View {
    // MARK: Data In
    let word: Word
    
    // MARK: Data Shared with Me
    @Binding var selection: Int
    
    // MARK: Data (sort of) In Function
    @ViewBuilder let ancillaryView: () -> AncillaryView
    
    // MARK: Data Owned by Me
    @Namespace private var selectionNamespace
    
    init(
        word: Word,
        selection: Binding<Int> = .constant(-1),
        @ViewBuilder ancillaryView: @escaping () -> AncillaryView = { EmptyView() }
    ) {
        self.word = word
        self._selection = selection
        self.ancillaryView = ancillaryView
    }
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            ForEach(word.letters.indices, id: \.self) { index in
                LetterView(letter: word.letters[index])
                    .padding(Selection.border)
                    .background { // selection background
                        Group {
                            if selection == index, word.kind == .guess {
                                Selection.shape
                                    .foregroundStyle(Selection.color)
                                    .matchedGeometryEffect(id: "selection", in: selectionNamespace)
                            }
                            
                            if let matches = word.matches {
                                switch matches[index] {
                                case .exact:
                                    Color.green
                                case .inexact:
                                    Color.yellow
                                default:
                                    Color.clear
                                }
                            }
                            
                        }
                        //.animation(.selection, value: selection)
                    }
                    .overlay { // hidden code obscuring
                        Selection.shape
                            .foregroundStyle(word.isHidden ? Color.gray : .clear)
                            .transaction { transaction in
                                if word.isHidden {
                                    transaction.animation = nil
                                }
                            }
                    }
                    .onTapGesture {
                        if word.kind == .guess {
                            selection = index
                        }
                    }
            }
            Color.clear.aspectRatio(1, contentMode: .fit)
                .overlay {
                    ancillaryView()
                }
        }

    }
}

fileprivate struct Selection {
    static let border: CGFloat = 5
    static let cornerRadius: CGFloat = 10
    static let color: Color = Color.gray(0.85)
    static let shape = RoundedRectangle(cornerRadius: cornerRadius)
}
