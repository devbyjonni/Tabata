//
//  StatsView.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-13.
//

import SwiftUI

struct StatsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showHistory = false
    
    var body: some View {
        NavigationStack {
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
