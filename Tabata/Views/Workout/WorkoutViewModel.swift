//
//  WorkoutViewModel.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-12.
//

import Foundation

/// Manages the active workout state, timer logic, and phase transitions.
/// Coordinates the flow from Warm Up -> Work -> Rest -> Cool Down.
@Observable
final class WorkoutViewModel {
    /// The current phase of the workout (e.g., .work, .rest).
    var phase: WorkoutPhase = .idle
    
    /// Time remaining in the current phase (in seconds).
    var timeRemaining: Double = 0
    
    /// Total duration of the current phase (used for progress calculation).
    var totalTime: Double = 1 // Avoid division by zero
    
    /// Whether the timer is currently running.
    var isActive: Bool = false
    
    /// Flag indicating if the entire workout sequence is complete.
    var isFinished: Bool = false
    
    /// Progress of the current phase (0.0 to 1.0).
    /// Used for visualizing the timer ring.
    var progress: Double {
        guard totalTime > 0 else { return 0 }
        return timeRemaining / totalTime
    }
    
    private var config: TabataConfiguration?
    
    /// The current set number within the current round.
    var currentSet = 1
    
    /// The current round number.
    var currentRound = 1
    
    var totalSets: Int { config?.sets ?? 0 }
    var totalRounds: Int { config?.rounds ?? 0 }
    
    private var settings: TabataSettings?
    private var lastIntegerTime: Int = 0
    
    /// Sets up the workout state without starting the timer.
    func setup(config: TabataConfiguration, settings: TabataSettings) {
        self.config = config
        self.settings = settings
        self.currentSet = 1
        self.currentRound = 1
        self.isFinished = false
        
        self.phase = .warmUp
        self.timeRemaining = config.warmUpTime
        self.totalTime = config.warmUpTime > 0 ? config.warmUpTime : 1
        
        // Initialize logic state
        self.lastIntegerTime = Int(ceil(timeRemaining))
        
        self.isActive = false
    }
    
    /// Starts or resumes the timer.
    func play() {
        if !isActive && timeRemaining == totalTime {
            // Initial Start (or restart of phase, but mostly for first launch)
            // If it's the very start of the workout (warmup), speak.
            if phase == .warmUp && timeRemaining == config?.warmUpTime {
                 speakPhase()
            }
        }
        isActive = true
    }
    
    private func speakPhase() {
        guard let settings = settings, settings.isSoundEnabled else { return }
        
        let text: String
        switch phase {
        case .warmUp: text = "Warm Up"
        case .work: text = "Work"
        case .rest: text = "Rest"
        case .coolDown: text = "Cool Down"
        case .idle: return
        }
        
        SoundManager.shared.speak(text)
    }
    
    /// Ticks the timer down by 0.05 seconds.
    func tick() {
        guard isActive else { return }
        
        let step = 0.05
        
        // 2. Decrement Phase Time (Logic handles transitions instantly)
        var timeToProcess = step
        
        while timeToProcess > 0.0001 && !isFinished {
            if timeRemaining > timeToProcess + 0.0001 {
                // Current phase has enough time
                timeRemaining -= timeToProcess
                timeToProcess = 0
                
                // Sound Check
                if let settings = settings, settings.isSoundEnabled && settings.isCountdownEnabled {
                    let currentIntegerTime = Int(ceil(timeRemaining))
                    if currentIntegerTime != lastIntegerTime {
                        // Integer boundary crossed
                        if currentIntegerTime <= 3 && currentIntegerTime > 0 {
                            SoundManager.shared.playBeep()
                        }
                        lastIntegerTime = currentIntegerTime
                    }
                }
            } else {
                // Phase finished (consume remaining time)
                timeToProcess -= timeRemaining
                timeRemaining = 0
                
                // Switch to next phase
                nextPhase()
            }
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
            lastIntegerTime = Int(ceil(timeRemaining))
            speakPhase()
            
        case .work:
            // 2. Work Finished -> Check what's next
            if currentSet == config.sets && currentRound == config.rounds {
                // All sets and rounds done -> Cool Down
                phase = .coolDown
                timeRemaining = config.coolDownTime
                totalTime = config.coolDownTime > 0 ? config.coolDownTime : 1
                lastIntegerTime = Int(ceil(timeRemaining))
                speakPhase()
            } else {
                // More work to do -> Rest
                phase = .rest
                timeRemaining = config.restTime
                totalTime = config.restTime > 0 ? config.restTime : 1
                lastIntegerTime = Int(ceil(timeRemaining))
                speakPhase()
            }
            
        case .rest:
            // 3. Rest Finished -> Start next Work segment
            if currentSet < config.sets {
                // Next Set in current Round
                currentSet += 1
                phase = .work
                timeRemaining = config.workTime
                totalTime = config.workTime > 0 ? config.workTime : 1
                lastIntegerTime = Int(ceil(timeRemaining))
                speakPhase()
            } else if currentRound < config.rounds {
                // Next Round (Reset Sets)
                currentRound += 1
                currentSet = 1
                phase = .work
                timeRemaining = config.workTime
                totalTime = config.workTime > 0 ? config.workTime : 1
                lastIntegerTime = Int(ceil(timeRemaining))
                speakPhase()
            } else {
                // Fallback: This path should technically be unreachable if logic in .work is correct,
                // but if we end up here, go to Cool Down.
                phase = .coolDown
                timeRemaining = config.coolDownTime
                totalTime = config.coolDownTime > 0 ? config.coolDownTime : 1
                lastIntegerTime = Int(ceil(timeRemaining))
                speakPhase()
            }
            
        case .coolDown:
            // 4. Cool Down Finished -> Done
            isFinished = true
            isActive = false
            timeRemaining = 0
            SoundManager.shared.speak("Workout Completed")
        }
    }
    
    /// Pauses the timer.
    func pause() {
        isActive = false
    }
    
    /// Skips to the next phase.
    func skip() {
        nextPhase()
    }
    
    /// Stops the workout.
    func stop() {
        isActive = false
        isFinished = false
        phase = .idle
        timeRemaining = 0
    }
    
    /// Generates a CompletedWorkout object based on the current configuration.
    /// Used for saving history and testing completion logic.
    func generateCompletedWorkout() -> CompletedWorkout? {
        guard let config = config else { return nil }
        
        let warmUp = config.warmUpTime
        let work = config.workTime * Double(config.sets * config.rounds)
        let rest = config.restTime * Double((config.sets - 1) * config.rounds)
        let coolDown = config.coolDownTime
        let totalDuration = warmUp + work + rest + coolDown
        
        return CompletedWorkout(
            duration: totalDuration,
            totalWarmUp: warmUp,
            totalWork: work,
            totalRest: rest,
            totalCoolDown: coolDown,
            calories: Int(totalDuration * 0.15), // Estimate: ~9 kcal/min
            avgHeartRate: Int.random(in: 130...160) // Simulation
        )
    }
}
