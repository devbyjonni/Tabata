//
//  SettingsView.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-13.
//

import SwiftUI
import SwiftData

/// App settings screen.
/// Allows configuration of globally applied preferences like Dark Mode.
struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var settings: [TabataSettings]
    
    var body: some View {
        ZStack {
            Color.slate900.ignoresSafeArea()
            
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
                            Toggle("Sound Effects", isOn: Bindable(currentSettings).isSoundEnabled)
                            Toggle("Countdown", isOn: Bindable(currentSettings).isCountdownEnabled)
                        } header: {
                            Text("Sound & Feedback")
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
