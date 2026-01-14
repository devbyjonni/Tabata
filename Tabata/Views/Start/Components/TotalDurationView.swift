//  TotalDurationView.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-13.
//

import SwiftUI
import SwiftData

/// Displays the total calculated duration of the workout.
/// Updates dynamically based on changes to sets, rounds, and intervals.
struct TotalDurationView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var configurations: [TabataConfiguration]
    
    private var viewModel: StartViewModel = StartViewModel()
    
    var body: some View {
        VStack(spacing: 5) {
            Text(viewModel.calculateTotalDuration(configurations: configurations).formatTime())
                .font(.system(size: 80, weight: .black, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(.white)
            
            Text("MINUTES TOTAL")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .tracking(2)
                .foregroundStyle(Color.slate400)
        }
        .padding(.top, 20)
    }
}


