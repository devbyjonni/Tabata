//
//  TimerTextView.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-13.
//

import SwiftUI
import SwiftData

struct TimerTextView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var configurations: [TabataConfiguration]
    @Query private var settings: [TabataSettings]
    
    private var viewModel: StartViewModel = StartViewModel()
    
    var body: some View {
        VStack(spacing: 5) {
            Text(viewModel.calculateTotalDuration(configurations: configurations).formatTime())
                .font(.system(size: 80, weight: .black, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(settings.first?.isDarkMode ?? true ? .white : Color.slate900)
            
            Text("MINUTES TOTAL")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .tracking(2)
                .foregroundStyle(settings.first?.isDarkMode ?? true ? Color.slate400 : Color.slate900.opacity(0.6))
        }
        .padding(.top, 20)
    }
}

#Preview {
    TimerTextView()
        .modelContainer(for: TabataConfiguration.self, inMemory: true)
}
