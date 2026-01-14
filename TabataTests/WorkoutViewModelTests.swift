//
//  WorkoutViewModelTests.swift
//  TabataTests
//
//  Created by Jonni Åkesson on 2026-01-12.
//

import XCTest
@testable import Tabata

final class WorkoutViewModelTests: XCTestCase {
    
    var viewModel: WorkoutViewModel!
    var config: TabataConfiguration!
    var settings: TabataSettings!
    
    override func setUp() {
        super.setUp()
        viewModel = WorkoutViewModel()
        settings = TabataSettings()
        // Standard config for testing transitions
        config = TabataConfiguration(
            sets: 2,
            rounds: 2,
            warmUpTime: 5,
            workTime: 10,
            restTime: 5,
            coolDownTime: 5
        )
    }
    
    override func tearDown() {
        viewModel = nil
        config = nil
        settings = nil
        super.tearDown()
    }
    
    func testInitialization() {
        viewModel.setup(config: config, settings: settings)
        viewModel.play()
        
        XCTAssertTrue(viewModel.isActive)
        XCTAssertEqual(viewModel.phase, .warmUp)
        XCTAssertEqual(viewModel.timeRemaining, 5, accuracy: 0.1)
        XCTAssertEqual(viewModel.totalTime, 5)
        XCTAssertEqual(viewModel.progress, 1.0)
    }
    
    func testWarmUpToWork() {
        viewModel.setup(config: config, settings: settings)
        viewModel.play()
        
        // Tick through Warm Up (5s)
        advanceTime(seconds: 5)
        
        XCTAssertEqual(viewModel.phase, .work)
        XCTAssertEqual(viewModel.timeRemaining, 10, accuracy: 0.1) // Work time
        XCTAssertEqual(viewModel.currentSet, 1)
        XCTAssertEqual(viewModel.currentRound, 1)
    }
    
    func testWorkToRest() {
        viewModel.setup(config: config, settings: settings)
        viewModel.play()
        
        // Skip to Work Phase
        advanceToPhase(.work)
        
        // Tick through Work (10s)
        advanceTime(seconds: 10)
        
        XCTAssertEqual(viewModel.phase, .rest)
        XCTAssertEqual(viewModel.timeRemaining, 5, accuracy: 0.1) // Rest time
    }
    
    func testRestToNextSet() {
        viewModel.setup(config: config, settings: settings) // 2 Sets configured
        viewModel.play()
        
        // Skip to Rest Phase (Set 1)
        advanceToPhase(.rest)
        
        // Tick through Rest (5s)
        advanceTime(seconds: 5)
        
        XCTAssertEqual(viewModel.phase, .work)
        XCTAssertEqual(viewModel.currentSet, 2) // Incremented
        XCTAssertEqual(viewModel.currentRound, 1) // Same round
    }
    
    func testRestToNextRound() {
        viewModel.setup(config: config, settings: settings) // 2 Sets, 2 Rounds
        viewModel.play()
        
        // Advance to End of Set 2 (Rest 2)
        // 1. WarmUp -> Work 1
        advanceToPhase(.work)
        // 2. Work 1 -> Rest 1
        advanceToPhase(.rest)
        // 3. Rest 1 -> Work 2 (Set 2)
        advanceToPhase(.work)
        // 4. Work 2 -> Rest 2 (End of Round 1 logic)
        advanceToPhase(.rest)
        
        // Now at Rest 2. Completing this should trigger Round 2, Set 1.
        // Tick through Rest (5s)
        advanceTime(seconds: 5)
        
        XCTAssertEqual(viewModel.phase, .work)
        XCTAssertEqual(viewModel.currentSet, 1) // Reset to 1
        XCTAssertEqual(viewModel.currentRound, 2) // Incremented to 2
    }
    
    func testWorkToCoolDown() {
        // Config: 1 Set, 1 Round to reach Cool Down quickly
        config = TabataConfiguration(sets: 1, rounds: 1, warmUpTime: 5, workTime: 10, restTime: 5, coolDownTime: 5)
        viewModel.setup(config: config, settings: settings)
        viewModel.play()
        
        // WarmUp -> Work
        advanceToPhase(.work)
        
        // Complete Work
        advanceTime(seconds: 10)
        
        XCTAssertEqual(viewModel.phase, .coolDown)
        XCTAssertEqual(viewModel.timeRemaining, 5, accuracy: 0.1)
    }
    
    func testCoolDownToFinish() {
        // Config to reach CoolDown immediately after Work
        config = TabataConfiguration(sets: 1, rounds: 1, warmUpTime: 0, workTime: 0, restTime: 0, coolDownTime: 5)
        viewModel.setup(config: config, settings: settings)
        viewModel.play()
        
        // Manually force CoolDown for speed
        advanceToPhase(.coolDown)
        
        // Complete CoolDown
        advanceTime(seconds: 5)
        
        // Check for finished state
        XCTAssertTrue(viewModel.isFinished)
        XCTAssertFalse(viewModel.isActive)
    }
    
    func testGenerateCompletedWorkout() {
        // Config: 2 Sets, 2 Rounds
        // WarmUp: 5
        // Work: 10 * 4 = 40
        // Rest: 5 * 2 = 10 (Rest occurs between sets: (2-1) * 2 rounds)
        // CoolDown: 5
        // Total: 60
        config = TabataConfiguration(sets: 2, rounds: 2, warmUpTime: 5, workTime: 10, restTime: 5, coolDownTime: 5)
        viewModel.setup(config: config, settings: settings)
        
        guard let workout = viewModel.generateCompletedWorkout() else {
            XCTFail("Failed to generate workout")
            return
        }
        
        XCTAssertEqual(workout.duration, 60, accuracy: 0.1)
        XCTAssertEqual(workout.totalWarmUp, 5, accuracy: 0.1)
        XCTAssertEqual(workout.totalWork, 40, accuracy: 0.1)
        XCTAssertEqual(workout.totalRest, 10, accuracy: 0.1)
        XCTAssertEqual(workout.totalCoolDown, 5, accuracy: 0.1)
        XCTAssertEqual(workout.calories, 9) // 60 * 0.15
        XCTAssertTrue((130...160).contains(workout.avgHeartRate))
    }
    
    // MARK: - Helper
    
    private func advanceTime(seconds: Double) {
        let ticks = Int(seconds / 0.05)
        for _ in 0..<ticks {
            viewModel.tick()
        }
    }
    
    private func advanceToPhase(_ targetPhase: BoxedWorkoutPhase) {
        // Safety limit to prevent infinite loops (increased for higher tick rate)
        var limit = 100000
        while viewModel.phase != targetPhase.phase && limit > 0 {
            viewModel.tick()
            limit -= 1
        }
    }
    
    // Helper enum for easier testing comparison since WorkoutPhase is in main target
    enum BoxedWorkoutPhase {
        case warmUp, work, rest, coolDown
        
        var phase: WorkoutPhase {
            switch self {
            case .warmUp: return .warmUp
            case .work: return .work
            case .rest: return .rest
            case .coolDown: return .coolDown
            }
        }
    }
}
