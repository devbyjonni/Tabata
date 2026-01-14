//
//  StatsListView.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-13.
//

import SwiftUI
import SwiftData

/// Displays a detailed list of all completed workouts.
struct StatsListView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack {
            Color.slate900.ignoresSafeArea()
            
            VStack(spacing: 0) {
                NavbarView(
                    title: "History",
                    leftIcon: Icons.back.rawValue,
                    rightIcon: "",
                    leftAction: { dismiss() },
                    rightAction: {}
                )
                
                Spacer()
                
                Text("Workout history coming soon...")
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
                
                Spacer()
            }
        }
    }
}

#Preview {
    StatsListView()
}
