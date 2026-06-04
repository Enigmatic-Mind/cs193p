//
//  Color.swift
//  CodeBreaker
//
//  Created by Francisco on 5/25/26.
//

import SwiftUI

extension Color {
    init?(name: String) {
        switch name {
        case "red":     self = .red
        case "orange":  self = .orange
        case "yellow":  self = .yellow
        case "green":   self = .green
        case "mint":    self = .mint
        case "teal":    self = .teal
        case "cyan":    self = .cyan
        case "blue":    self = .blue
        case "indigo":  self = .indigo
        case "purple":  self = .purple
        case "pink":    self = .pink
        case "brown":   self = .brown
        case "white":   self = .white
        case "gray":    self = .gray
        case "black":   self = .black
        default:        return nil
        }
    }

    var name: String? {
        switch self {
        case .red:      return "red"
        case .orange:   return "orange"
        case .yellow:   return "yellow"
        case .green:    return "green"
        case .mint:     return "mint"
        case .teal:     return "teal"
        case .cyan:     return "cyan"
        case .blue:     return "blue"
        case .indigo:   return "indigo"
        case .purple:   return "purple"
        case .pink:     return "pink"
        case .brown:    return "brown"
        case .white:    return "white"
        case .gray:     return "gray"
        case .black:    return "black"
        default:        return nil
        }
    }
}
