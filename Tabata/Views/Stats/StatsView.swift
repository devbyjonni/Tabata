//
//  StatsView.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-13.
//

import SwiftUI
import SwiftData

/// Displays aggregate workout statistics.
/// Provides entry point to detailed workout history.
struct StatsView: View {
    @Environment(\.dismiss) var dismiss
    @Query private var settings: [TabataSettings]
    
    @State private var showHistory = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                (settings.first?.isDarkMode ?? true ? Color.slate900 : Theme.background)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    NavbarView(
                        title: "Stats",
                        leftIcon: Icons.xmark.rawValue,
                        rightIcon: Icons.list.rawValue,
                        leftAction: { dismiss() },
                        rightAction: { showHistory = true }
                    )
                    
                    Spacer()
                    
                    Text("Statistics coming soon...")
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
            }
            .navigationDestination(isPresented: $showHistory) {
                StatsListView()
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}

#Preview {
    StatsView()
}
