//
//  CodeView.swift
//  CodeBreaker
//
//  Created by Francisco on 5/26/26.
//

import SwiftUI

struct CodeView<AncillaryView>: View where AncillaryView: View {
    //MARK: - Data In
    let code: Code
    
    //MARK: - Data Shared with me
    @Binding var selection: Int
    
    //MARK: - Data in Function
    @ViewBuilder let ancillaryView: () -> AncillaryView
    
    //MARK: - Data owned by me
    @Namespace private var selectionNamespace
    
    init(
        code: Code,
        selection: Binding<Int> = .constant(-1),
        @ViewBuilder ancillaryView: @escaping () -> AncillaryView = { EmptyView() }
    ) {
        self.code = code
        self._selection = selection
        self.ancillaryView = ancillaryView
    }

    //MARK: - Body
//    var body: some View {
//        ForEach(code.pegs.indices, id: \.self) { index in
//            PegView(peg: code.pegs[index])
//                .padding(Selection.border)
//                .background {
//                    if selection == index, code.kind == .guess {
//                        Selection.shape
//                            .foregroundStyle(Selection.color)
//                    }
//                }
//                .overlay {
//                    Selection.shape.foregroundStyle(code.isHidden ? Color.gray : .clear)
//                }
//                .onTapGesture {
//                    if code.kind == .guess {
//                        selection = index
//                    }
//                }
//        }
//        
//    }
    
    var body: some View {
        HStack {
            ForEach(code.pegs.indices, id: \.self) { index in
                PegView(peg: code.pegs[index])
                    .padding(Selection.border)
                    .background { // selection background
                        Group {
                            if selection == index, code.kind == .guess {
                                Selection.shape
                                    .foregroundStyle(Selection.color)
                                    .matchedGeometryEffect(id: "selection", in: selectionNamespace)
                            }
                        }
                        .animation(.selection, value: selection)
                    }
                    .overlay { // hidden code obscuring
                        Selection.shape.foregroundStyle(code.isHidden ? Color.gray : .clear)
                            .transaction { transaction in
                                if code.isHidden { // only animate when not hidden
                                    transaction.animation = nil
                                }
                            }
                    }
                    .onTapGesture {
                        if code.kind == .guess {
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
    static let shape = RoundedRectangle(cornerRadius: Selection.cornerRadius)
}

//#Preview {
//    CodeView()
//}
