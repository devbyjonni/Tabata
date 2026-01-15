//
//  WorkoutStatisticsGrid.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-14.
//

import SwiftUI

struct WorkoutStatisticsGrid: View {
    let duration: TimeInterval
    let warmUp: TimeInterval
    let work: TimeInterval
    let rest: TimeInterval
    let coolDown: TimeInterval
    let reps: Int
    var workoutCount: Int? = nil
    
    var body: some View {
        VStack(spacing: 12) {

            
            // Total Duration Card
            StatsSummaryCard(
                title: "DURATION",
                value: duration.formatTime(),
                icon: Icons.clock.rawValue,
                iconColor: Color.slate500.opacity(0.5)
            )
            
            // Phase Breakdown Grid
            HStack(spacing: 12) {
                // Left Column
                VStack(spacing: 12) {
                    StatCard(
                        title: "WARMUP",
                        value: warmUp.formatTime(),
                        color: Theme.warmup,
                        icon: Icons.warmUp.rawValue
                    )
                    StatCard(
                        title: "REST",
                        value: rest.formatTime(),
                        color: Theme.rest,
                        icon: Icons.rest.rawValue
                    )
                }
                
                // Right Column
                VStack(spacing: 12) {
                    StatCard(
                        title: "WORK",
                        value: work.formatTime(),
                        color: Theme.work,
                        icon: Icons.work.rawValue
                    )
                    StatCard(
                        title: "COOL DOWN",
                        value: coolDown.formatTime(),
                        color: Theme.cooldown,
                        icon: Icons.cooldown.rawValue
                    )
                }
            }
            
            // Bottom Row: Workouts & Reps
            HStack(spacing: 12) {
                // Workouts
                HStack {
                    ZStack {
                        Circle()
                            .fill(Color.yellow.opacity(0.2))
                            .frame(width: 32, height: 32)
                        Image(systemName: Icons.trophy.rawValue)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.yellow)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("WORKOUTS")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(Color.slate400)
                        Text(workoutCount != nil ? "\(workoutCount!)" : "-")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                    }
                    Spacer()
                }
                .padding(24)
                .background(Color.slate800)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
                .shadow(color: .clear, radius: 10, x: 0, y: 4)
                
                // Reps
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("TOTAL REPS")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(Color.slate400)
                        Text("\(reps)")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                    }
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.2))
                            .frame(width: 32, height: 32)
                        Image(systemName: Icons.repeatIcon.rawValue)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.blue)
                    }
                }
                .padding(24)
                .background(Color.slate800)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
                .shadow(color: .clear, radius: 10, x: 0, y: 4)
            }
        }
    }
}

// Internal Stat Card Component
fileprivate struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top) {
                Text(title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.white.opacity(0.9))
            }
            .padding(.bottom, 24)
            
            Text(value)
                .font(.system(size: 28, weight: .black, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(.white)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: .clear, radius: 8, x: 0, y: 4)
    }
}
