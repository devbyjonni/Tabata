//  TotalDurationView.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-13.
//

import SwiftUI
import SwiftData

/// Displays the total estimated duration of the workout.
///
/// It queries `TabataConfiguration` directly to compute the total time
/// via its `totalDuration` computed property.
struct TotalDurationView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var configurations: [TabataConfiguration]
    
    var body: some View {
        VStack(spacing: 5) {
            Text((configurations.first?.totalDuration ?? 0).formatTime())
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
