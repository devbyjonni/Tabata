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
    let calories: Int
    let avgHeartRate: Int
    var workoutCount: Int? = nil
    
    var body: some View {
        VStack(spacing: 12) {
            // Total Workouts (Optional)
            if let workoutCount = workoutCount {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("TOTAL WORKOUTS")
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .tracking(1)
                            .foregroundStyle(Color.slate400)
                            .textCase(.uppercase)
                        
                        Text("\(workoutCount)")
                            .font(.system(size: 40, weight: .black, design: .rounded))
                            .monospacedDigit()
                            .foregroundStyle(.white)
                    }
                    Spacer()
                    Image(systemName: Icons.trophy.rawValue)
                        .font(.system(size: 40))
                        .foregroundStyle(Color.yellow.opacity(0.8))
                }
                .padding(24)
                .background(Color.slate800)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
            }
            
            // Total Duration Card
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("TOTAL DURATION")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .tracking(1)
                        .foregroundStyle(Color.slate400)
                        .textCase(.uppercase)
                    
                    Text(duration.formatTime())
                        .font(.system(size: 40, weight: .black, design: .rounded))
                        .monospacedDigit()
                        .foregroundStyle(.white)
                }
                Spacer()
                Image(systemName: Icons.clock.rawValue)
                    .font(.system(size: 40))
                    .foregroundStyle(Color.slate500.opacity(0.5))
            }
            .padding(24)
            .background(Color.slate800)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
            
            // Phase Breakdown Grid
            HStack(spacing: 12) {
                // Left Column
                VStack(spacing: 12) {
                    StatCard(
                        title: "TOTAL WARMUP",
                        value: warmUp.formatTime(),
                        color: Theme.warmup,
                        icon: Icons.warmUp.rawValue
                    )
                    StatCard(
                        title: "TOTAL REST",
                        value: rest.formatTime(),
                        color: Theme.rest,
                        icon: Icons.rest.rawValue
                    )
                }
                
                // Right Column
                VStack(spacing: 12) {
                    StatCard(
                        title: "TOTAL WORK",
                        value: work.formatTime(),
                        color: Theme.work,
                        icon: Icons.work.rawValue
                    )
                    StatCard(
                        title: "TOTAL COOL DOWN",
                        value: coolDown.formatTime(),
                        color: Theme.cooldown,
                        icon: Icons.cooldown.rawValue
                    )
                }
            }
            
            // Bottom Row: Calories & Heart Rate
            HStack(spacing: 12) {
                // Calories
                HStack {
                    ZStack {
                        Circle()
                            .fill(Color.green.opacity(0.2))
                            .frame(width: 32, height: 32)
                        Image(systemName: Icons.flame.rawValue)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.green)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("EST. CALORIES")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundStyle(Color.slate400)
                        Text("\(calories) kcal")
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
                
                // Heart Rate
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("AVG HR")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundStyle(Color.slate400)
                        Text("\(avgHeartRate)")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                    }
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .fill(Color.red.opacity(0.2))
                            .frame(width: 32, height: 32)
                        Image(systemName: Icons.heart.rawValue)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.red)
                    }
                }
                .padding(24)
                .background(Color.slate800)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
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
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(.white.opacity(0.9))
                Spacer()
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundStyle(.white.opacity(0.3))
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
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        WorkoutStatisticsGrid(
            duration: 90,
            warmUp: 30,
            work: 15,
            rest: 15,
            coolDown: 30,
            calories: 13,
            avgHeartRate: 145
        )
        .padding()
    }
}
