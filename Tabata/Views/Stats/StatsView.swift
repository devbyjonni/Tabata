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
    @Query(sort: \CompletedWorkout.date, order: .reverse) private var history: [CompletedWorkout]
    @State private var showHistory = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.slate900.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    NavbarView(
                        title: "Overview",
                        leftIcon: Icons.xmark.rawValue,
                        rightIcon: Icons.list.rawValue,
                        leftAction: { dismiss() },
                        rightAction: { showHistory = true }
                    )
                    
                    ScrollView {
                        if history.isEmpty {
                            VStack(spacing: 16) {
                                Spacer(minLength: 100)
                                Image(systemName: "chart.bar.xaxis")
                                    .font(.system(size: 60))
                                    .foregroundStyle(Color.slate700)
                                Text("No workouts yet")
                                    .font(.system(size: 18, weight: .medium, design: .rounded))
                                    .foregroundStyle(Color.slate500)
                            }
                        } else {
                            // Calculate Aggregates
                            let totalDuration = history.reduce(0) { $0 + $1.duration }
                            let totalWarmUp = history.reduce(0) { $0 + $1.totalWarmUp }
                            let totalWork = history.reduce(0) { $0 + $1.totalWork }
                            let totalRest = history.reduce(0) { $0 + $1.totalRest }
                            let totalCoolDown = history.reduce(0) { $0 + $1.totalCoolDown }
                            let totalCalories = history.reduce(0) { $0 + $1.calories }
                            let avgHR = history.isEmpty ? 0 : history.reduce(0) { $0 + $1.avgHeartRate } / history.count
                            
                            WorkoutStatisticsGrid(
                                duration: totalDuration,
                                warmUp: totalWarmUp,
                                work: totalWork,
                                rest: totalRest,
                                coolDown: totalCoolDown,
                                calories: totalCalories,
                                avgHeartRate: avgHR
                            )
                            .padding()
                        }
                    }
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
