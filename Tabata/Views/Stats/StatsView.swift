//
//  StatsView.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-13.
//

import SwiftUI

struct StatsView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            NavbarView(
                title: "Stats",
                leftIcon: Icons.xmark.rawValue,
                rightIcon: "",
                leftAction: { dismiss() },
                rightAction: {}
            )
            
            Spacer()
            
            Text("Statistics coming soon...")
                .font(.system(size: 20, weight: .medium, design: .rounded))
                .foregroundColor(.secondary)
            
            Spacer()
        }
    }
}

#Preview {
    StatsView()
}
