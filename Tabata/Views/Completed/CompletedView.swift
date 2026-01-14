//
//  CompletedView.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-13.
//

import SwiftUI
import SwiftData

/// Displayed when a workout is finished.
/// Shows a summary and allows the user to return to the start screen.
struct CompletedView: View {
    var workout: CompletedWorkout?
    var action: () -> Void = {}
    @Query(sort: \CompletedWorkout.date, order: .reverse) private var history: [CompletedWorkout]
    
    var body: some View {
        ZStack {
            Color.slate900.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                NavbarView(
                    title: "Completed",
                    leftIcon: Icons.xmark.rawValue,
                    rightIcon: Icons.share.rawValue,
                    leftAction: { action() },
                    rightAction: {
                        // Share logic placeholder
                    }
                )
                
                ScrollView {
                    VStack(spacing: 32) {
                        // Hero Section
                        VStack(spacing: 24) {
                            ZStack {
                                // Glow
                                Circle()
                                    .fill(Color.yellow.opacity(0.15))
                                    .frame(width: 140, height: 140)
                                    .blur(radius: 30)
                                
                                // Trophy Ring
                                Circle()
                                    .stroke(Color.yellow, lineWidth: 3)
                                    .frame(width: 100, height: 100)
                                
                                // Trophy Icon
                                Image(systemName: Icons.trophy.rawValue)
                                    .font(.system(size: 44))
                                    .foregroundStyle(.yellow)
                            }
                            
                            VStack(spacing: 8) {
                                Text("Congratulations!")
                                    .font(.system(size: 32, weight: .black, design: .rounded))
                                    .foregroundStyle(.white)
                                
                                Text("You crushed your session.")
                                    .font(.system(size: 17, weight: .medium, design: .rounded))
                                    .foregroundStyle(Color.slate400)
                            }
                        }
                        .padding(.top, 0)
                        
                        // Stats Grid
                        if let workout = workout ?? history.first {
                            WorkoutStatisticsGrid(
                                duration: workout.duration,
                                warmUp: workout.totalWarmUp,
                                work: workout.totalWork,
                                rest: workout.totalRest,
                                coolDown: workout.totalCoolDown,
                                calories: workout.calories,
                                avgHeartRate: workout.avgHeartRate
                            )
                        } else {
                            Text("No Statistics Available\n(Workout: \(workout == nil ? "nil" : "ok"), History: \(history.count))")
                                .multilineTextAlignment(.center)
                                .foregroundStyle(Color.slate500)
                                .padding()
                        }
                        
                        // Bottom Padding
                        Color.clear.frame(height: 20)
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    CompletedView()
}
