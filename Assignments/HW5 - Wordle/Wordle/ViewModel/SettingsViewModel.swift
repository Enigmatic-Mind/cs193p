//
//  SettingsViewModel.swift
//  Wordle
//
//  Created by Francisco on 6/16/26.
//

import Foundation

@Observable class SettingsViewModel {
    static let shared = SettingsViewModel()
    var wordLength = 5
}
