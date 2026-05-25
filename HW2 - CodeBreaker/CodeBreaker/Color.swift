//
//  Color.swift
//  CodeBreaker
//
//  Created by Francisco on 5/25/26.
//

import SwiftUI

extension Color {
    
    static func from(peg: String) -> Color {
        switch peg {
        case "blue": return Color.blue
        case "green": return Color.green
        case "red": return Color.red
        case "yellow": return Color.yellow
        case "clear": return Color.clear
        default: return Color.black
        }
    }
    
}
