//
//  SettingsView.swift
//  Wordle
//
//  Created by Francisco on 6/16/26.
//

import SwiftUI

struct SettingsView: View {
    // MARK: Data (Function) In
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Word Length") {
                    Stepper("\(SettingsViewModel.shared.wordLength) letters", value: Binding(
                        get: { SettingsViewModel.shared.wordLength },
                        set: { SettingsViewModel.shared.wordLength = $0 }
                    ), in: 3...6)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
