//
//  WorkoutViewModel.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-12.
//

import Foundation

@Observable
final class WorkoutViewModel {
    var phase: WorkoutPhase = .idle
    var timeRemaining: Double = 0
    var totalTime: Double = 1 // Avoid division by zero
    var isActive: Bool = false
    
    var isFinished: Bool = false
    
    var progress: Double {
        guard totalTime > 0 else { return 0 }
        return timeRemaining / totalTime
    }
    
    private var config: TabataConfiguration?
    var currentSet = 1
    var currentRound = 1
    
    var totalSets: Int { config?.sets ?? 0 }
    var totalRounds: Int { config?.rounds ?? 0 }
    
    /// Sets up the workout state without starting the timer.
    func setup(config: TabataConfiguration) {
        self.config = config
        self.currentSet = 1
        self.currentRound = 1
        self.isFinished = false
        
        self.phase = .warmUp
        self.timeRemaining = config.warmUpTime
        self.totalTime = config.warmUpTime > 0 ? config.warmUpTime : 1
        self.isActive = false
    }
    
    /// Starts or resumes the timer.
    func play() {
        isActive = true
    }
    
    /// Ticks the timer down by 0.05 seconds.
    func tick() {
        guard isActive else { return }
        
        if timeRemaining > 0 {
            timeRemaining -= 0.05
        } else {
            nextPhase()
        }
    }
    
    /// Advances the workout to the next phase based on the current state.
    ///
    /// This method handles the state machine transitions:
    /// - **Warm Up** -> **Work**: Starts the first set of the first round.
    /// - **Work** -> **Rest**: If there are more sets in the current round.
    /// - **Work** -> **Cool Down**: If the last set of the last round is completed.
    /// - **Rest** -> **Work**: Advances to the next set.
    /// - **Rest** -> **Work (New Round)**: If sets are done but rounds remain, increments round and resets sets.
    /// - **Cool Down** -> **Idle**: Ends the workout.
    private func nextPhase() {
        guard let config = config else { return }
        
        switch phase {
        case .idle:
            // Should not happen if active, but safe to ignore.
            break
            
        case .warmUp:
            // 1. Warm Up Finished -> Start Work
            phase = .work
            timeRemaining = config.workTime
            totalTime = config.workTime > 0 ? config.workTime : 1
            
        case .work:
            // 2. Work Finished -> Check what's next
            if currentSet == config.sets && currentRound == config.rounds {
                // All sets and rounds done -> Cool Down
                phase = .coolDown
                timeRemaining = config.coolDownTime
                totalTime = config.coolDownTime > 0 ? config.coolDownTime : 1
            } else {
                // More work to do -> Rest
                phase = .rest
                timeRemaining = config.restTime
                totalTime = config.restTime > 0 ? config.restTime : 1
            }
            
        case .rest:
            // 3. Rest Finished -> Start next Work segment
            if currentSet < config.sets {
                // Next Set in current Round
                currentSet += 1
                phase = .work
                timeRemaining = config.workTime
                totalTime = config.workTime > 0 ? config.workTime : 1
            } else if currentRound < config.rounds {
                // Next Round (Reset Sets)
                currentRound += 1
                currentSet = 1
                phase = .work
                timeRemaining = config.workTime
                totalTime = config.workTime > 0 ? config.workTime : 1
            } else {
                // Fallback: This path should technically be unreachable if logic in .work is correct,
                // but if we end up here, go to Cool Down.
                phase = .coolDown
                timeRemaining = config.coolDownTime
                totalTime = config.coolDownTime > 0 ? config.coolDownTime : 1
            }
            
        case .coolDown:
            // 4. Cool Down Finished -> Done
            isFinished = true
            isActive = false
            timeRemaining = 0
        }
    }
    
    /// Stops the workout.
    func stop() {
        isActive = false
        isFinished = false
        phase = .idle
        timeRemaining = 0
    }
}
