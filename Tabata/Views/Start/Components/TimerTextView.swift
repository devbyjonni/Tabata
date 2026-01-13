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
    
    private var viewModel: StartViewModel = StartViewModel()
    
    var body: some View {
        VStack {
            Text(viewModel.calculateTotalDuration(configurations: configurations).formatTime())
                .font(.system(size: 34, weight: .bold, design: .rounded))
            Text("Minutes Total")
                .font(.system(size: 14, weight: .medium, design: .rounded))
        }
        .frame(height: 200)
        .frame(maxWidth: .infinity)
        .background(.gray.opacity(0.3)) // Debug
    }
}

#Preview {
    TimerTextView()
        .modelContainer(for: TabataConfiguration.self, inMemory: true)
}
