//
//  StatsListView.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-13.
//

import SwiftUI
import SwiftData

struct StatsListView: View {
    @Environment(\.dismiss) var dismiss
    @Query private var settings: [TabataSettings]
    
    var body: some View {
        ZStack {
            (settings.first?.isDarkMode ?? true ? Color.slate900 : Theme.background)
                .ignoresSafeArea()
            
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
