import Foundation
import Observation

/// Manages the active workout state, timer logic, and phase transitions.
/// Coordinates the flow from Warm Up -> Work -> Rest -> Cool Down.
@Observable
@MainActor
final class WorkoutViewModel {
    // --- State Properties ---
    var phase: WorkoutPhase = .idle
    var timeRemaining: Double = 0
    var totalTime: Double = 1 // Avoid division by zero
    var isActive: Bool = false
    var isFinished: Bool = false
    
    // --- UI & Configuration Helpers ---
    var currentSet = 1
    var currentRound = 1
    private var config: TabataConfiguration?
    private var settings: TabataSettings?
    private var lastIntegerTime: Int = 0
    
    // --- High-Precision Timing ---
    // We use ContinuousClock because it is monotonic (never jumps backwards) and
    // is unaffected by system time changes or suspended states.
    // This creates "Drift-Free" timing by relying on absolute duration
    // rather than accumulating error-prone relative ticks.
    private let timeProvider: () -> ContinuousClock.Instant
    private var lastTickTime: ContinuousClock.Instant?

    init(timeProvider: @escaping () -> ContinuousClock.Instant = { ContinuousClock().now }) {
        self.timeProvider = timeProvider
    }
    
    /// Progress of the current phase (0.0 to 1.0) for the UI ring.
    var progress: Double {
        guard totalTime > 0 else { return 0 }
        return timeRemaining / totalTime
    }

    var totalSets: Int { config?.sets ?? 0 }
    var totalRounds: Int { config?.rounds ?? 0 }

    // MARK: - Lifecycle

    func setup(config: TabataConfiguration, settings: TabataSettings) {
        self.config = config
        self.settings = settings
        self.currentSet = 1
        self.currentRound = 1
        self.isFinished = false
        
        self.phase = .warmUp
        self.timeRemaining = config.warmUpTime
        self.totalTime = config.warmUpTime > 0 ? config.warmUpTime : 1
        
        self.lastIntegerTime = Int(ceil(timeRemaining))
        self.isActive = false
        self.lastTickTime = nil
    }

    func play() {
        if !isActive && timeRemaining == totalTime {
            if phase == .warmUp && timeRemaining == config?.warmUpTime {
                speakPhase()
            }
        }
        isActive = true
        lastTickTime = timeProvider()
    }
    
    func pause() {
        isActive = false
        lastTickTime = nil
    }

    func stop() {
        isActive = false
        isFinished = false
        phase = .idle
        timeRemaining = 0
    }

    func skip() {
        nextPhase()
    }

    // MARK: - Timer Logic

    /// Ticks the timer using high-precision temporal deltas.
    func tick() {
        guard isActive else { return }
        
        let now = timeProvider()
        
        guard let lastTime = lastTickTime else {
            lastTickTime = now
            return
        }
        
        let delta = now - lastTime
        let deltaSeconds = delta / .seconds(1)
        lastTickTime = now
        
        processTime(deltaSeconds)
    }
    
    private func processTime(_ delta: Double) {
        var timeToProcess = delta
        
        // Loop to handle cases where the delta exceeds the remaining time in the current phase
        // (e.g. backgrounded app or long lag spike).
        // This ensures rigorous state handling: "Overshoot" time is correctly carried over
        // to the next phase, preserving exact workout duration over long periods.
        while timeToProcess > 0.0001 && !isFinished {
            if timeRemaining > timeToProcess + 0.0001 {
                // Normal tick
                timeRemaining -= timeToProcess
                
                let currentIntegerTime = Int(ceil(timeRemaining))
                if currentIntegerTime != lastIntegerTime {
                    if let settings = settings, settings.isSoundEnabled && settings.isCountdownEnabled {
                        if currentIntegerTime <= 3 && currentIntegerTime > 0 {
                            SoundManager.shared.playBeep()
                        }
                    }
                    lastIntegerTime = currentIntegerTime
                }
                timeToProcess = 0
            } else {
                // Phase Transition: Consume remaining time in this phase
                timeToProcess -= timeRemaining
                timeRemaining = 0
                nextPhase()
            }
        }
    }

    // MARK: - Phase Management

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

    private func nextPhase() {
        guard let config = config else { return }
        
        switch phase {
        case .idle:
            break
            
        case .warmUp:
            phase = .work
            timeRemaining = config.workTime
            totalTime = config.workTime > 0 ? config.workTime : 1
            lastIntegerTime = Int(ceil(timeRemaining))
            speakPhase()
            
        case .work:
            if currentSet == config.sets && currentRound == config.rounds {
                phase = .coolDown
                timeRemaining = config.coolDownTime
                totalTime = config.coolDownTime > 0 ? config.coolDownTime : 1
                lastIntegerTime = Int(ceil(timeRemaining))
                speakPhase()
            } else {
                phase = .rest
                timeRemaining = config.restTime
                totalTime = config.restTime > 0 ? config.restTime : 1
                lastIntegerTime = Int(ceil(timeRemaining))
                speakPhase()
            }
            
        case .rest:
            if currentSet < config.sets {
                currentSet += 1
                phase = .work
                timeRemaining = config.workTime
                totalTime = config.workTime > 0 ? config.workTime : 1
                lastIntegerTime = Int(ceil(timeRemaining))
                speakPhase()
            } else if currentRound < config.rounds {
                currentRound += 1
                currentSet = 1
                phase = .work
                timeRemaining = config.workTime
                totalTime = config.workTime > 0 ? config.workTime : 1
                lastIntegerTime = Int(ceil(timeRemaining))
                speakPhase()
            } else {
                phase = .coolDown
                timeRemaining = config.coolDownTime
                totalTime = config.coolDownTime > 0 ? config.coolDownTime : 1
                lastIntegerTime = Int(ceil(timeRemaining))
                speakPhase()
            }
            
        case .coolDown:
            isFinished = true
            isActive = false
            timeRemaining = 0
            SoundManager.shared.speak("Workout Completed")
        }
    }

    // MARK: - Stats Generation

    func generateCompletedWorkout() -> CompletedWorkout? {
        guard let config = config else { return nil }
        
        let warmUp = config.warmUpTime
        let work = config.workTime * Double(config.sets * config.rounds)
        let totalSegments = config.sets * config.rounds
        let rest = config.restTime * Double(max(0, totalSegments - 1))
        let coolDown = config.coolDownTime
        
        return CompletedWorkout(
            duration: config.totalDuration,
            totalWarmUp: warmUp,
            totalWork: work,
            totalRest: rest,
            totalCoolDown: coolDown,
            calories: Int(config.totalDuration * 0.15),
            avgHeartRate: Int.random(in: 130...160),
            reps: config.sets * config.rounds,
            rounds: config.rounds
        )
    }
}
