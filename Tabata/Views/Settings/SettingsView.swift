//
//  SettingsView.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-13.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var settings: [TabataSettings]
    
    var body: some View {
        ZStack {
            (settings.first?.isDarkMode ?? true ? Color.slate900 : Theme.background)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                NavbarView(
                    title: "Settings",
                    leftIcon: Icons.xmark.rawValue,
                    rightIcon: "",
                    leftAction: { dismiss() },
                    rightAction: {}
                )
                
                Form {
                    if let currentSettings = settings.first {
                        Section {
                            Toggle("Dark Mode", isOn: Bindable(currentSettings).isDarkMode)
                            Toggle("Sound Effects", isOn: Bindable(currentSettings).isSoundEnabled)
                            Toggle("Countdown", isOn: Bindable(currentSettings).isCountdownEnabled)
                        } header: {
                            Text("Appearance & Sound")
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
        }
    }
}

#Preview {
    SettingsView()
}
