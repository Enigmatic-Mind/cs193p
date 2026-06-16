//
//  WordleApp.swift
//  Wordle
//
//  Created by Francisco on 6/2/26.
//

import SwiftUI
import SwiftData

@main
struct WordleApp: App {
    var body: some Scene {
        WindowGroup {
            GameChooser()
                .modelContainer(for: WordBreaker.self)
        }
    }
}
