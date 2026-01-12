//
//  StartViewModel.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-12.
//

import Foundation

class StartViewModel {
    
    /// Calculates the total duration of the workout.
    /// - Parameter configurations: The list of Tabata configurations (uses the first one).
    /// - Returns: Total duration in seconds.
    func calculateTotalDuration(configurations: [TabataConfiguration]) -> Double {
        guard let configuration = configurations.first else { return 0 }
        
        let cycleDuration = configuration.workTime + configuration.restTime
        let totalCycleTime = Double(configuration.sets) * Double(configuration.rounds) * cycleDuration
        
        return configuration.warmUpTime + totalCycleTime + configuration.coolDownTime
    }
    
    /// Updates the number of sets.
    /// - Parameters:
    ///   - amount: The amount to add (can be negative).
    ///   - configurations: The list of Tabata configurations.
    func updateSets(by amount: Int, configurations: [TabataConfiguration]) {
        guard let configuration = configurations.first else { return }
        configuration.sets = min(10, max(1, configuration.sets + amount))
    }
    
    /// Updates the number of rounds.
    /// - Parameters:
    ///   - amount: The amount to add (can be negative).
    ///   - configurations: The list of Tabata configurations.
    func updateRounds(by amount: Int, configurations: [TabataConfiguration]) {
        guard let configuration = configurations.first else { return }
        configuration.rounds = min(10, max(1, configuration.rounds + amount))
    }
    
    /// Adjusts the time for a specific workout phase.
    /// - Parameters:
    ///   - phase: The phase to adjust (Warm Up, Work, Rest, Cool Down).
    ///   - seconds: The number of seconds to add (can be negative).
    ///   - configurations: The list of Tabata configurations.
    func adjustTime(for phase: WorkoutPhase, by seconds: Double, configurations: [TabataConfiguration]) {
        guard let configuration = configurations.first else { return }
        
        switch phase {
        case .warmUp:
            configuration.warmUpTime = min(600, max(0, configuration.warmUpTime + seconds))
        case .work:
            configuration.workTime = min(600, max(0, configuration.workTime + seconds))
        case .rest:
            configuration.restTime = min(600, max(0, configuration.restTime + seconds))
        case .coolDown:
            configuration.coolDownTime = min(600, max(0, configuration.coolDownTime + seconds))
        }
    }
}
