//
//  SettingsView.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-13.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            NavbarView(
                title: "Settings",
                leftIcon: Icons.xmark.rawValue,
                rightIcon: "",
                leftAction: { dismiss() },
                rightAction: {}
            )
            
            Spacer()
            
            Text("Settings coming soon...")
                .font(.system(size: 20, weight: .medium, design: .rounded))
                .foregroundColor(.secondary)
            
            Spacer()
        }
    }
}

#Preview {
    SettingsView()
}
