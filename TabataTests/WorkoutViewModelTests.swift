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
    
    override func setUp() {
        super.setUp()
        viewModel = WorkoutViewModel()
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
        super.tearDown()
    }
    
    func testInitialization() {
        viewModel.start(config: config)
        
        XCTAssertTrue(viewModel.isActive)
        XCTAssertEqual(viewModel.phase, .warmUp)
        XCTAssertEqual(viewModel.timeRemaining, 5)
        XCTAssertEqual(viewModel.totalTime, 5)
        XCTAssertEqual(viewModel.progress, 1.0)
    }
    
    func testWarmUpToWork() {
        viewModel.start(config: config)
        
        // Tick through Warm Up (5s)
        for _ in 1...5 { viewModel.tick() }
        // One more tick to trigger transition
        viewModel.tick()
        
        XCTAssertEqual(viewModel.phase, .work)
        XCTAssertEqual(viewModel.timeRemaining, 10) // Work time
        XCTAssertEqual(viewModel.currentSet, 1)
        XCTAssertEqual(viewModel.currentRound, 1)
    }
    
    func testWorkToRest() {
        viewModel.start(config: config)
        
        // Skip to Work Phase
        advanceToPhase(.work)
        
        // Tick through Work (10s)
        for _ in 1...10 { viewModel.tick() }
        // Transition
        viewModel.tick()
        
        XCTAssertEqual(viewModel.phase, .rest)
        XCTAssertEqual(viewModel.timeRemaining, 5) // Rest time
    }
    
    func testRestToNextSet() {
        viewModel.start(config: config) // 2 Sets configured
        
        // Skip to Rest Phase (Set 1)
        advanceToPhase(.rest)
        
        // Tick through Rest (5s)
        for _ in 1...5 { viewModel.tick() }
        // Transition
        viewModel.tick()
        
        XCTAssertEqual(viewModel.phase, .work)
        XCTAssertEqual(viewModel.currentSet, 2) // Incremented
        XCTAssertEqual(viewModel.currentRound, 1) // Same round
    }
    
    func testRestToNextRound() {
        viewModel.start(config: config) // 2 Sets, 2 Rounds
        
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
        for _ in 1...5 { viewModel.tick() }
        // Transition
        viewModel.tick()
        
        XCTAssertEqual(viewModel.phase, .work)
        XCTAssertEqual(viewModel.currentSet, 1) // Reset to 1
        XCTAssertEqual(viewModel.currentRound, 2) // Incremented to 2
    }
    
    func testWorkToCoolDown() {
        // Config: 1 Set, 1 Round to reach Cool Down quickly
        config = TabataConfiguration(sets: 1, rounds: 1, warmUpTime: 5, workTime: 10, restTime: 5, coolDownTime: 5)
        viewModel.start(config: config)
        
        // WarmUp -> Work
        advanceToPhase(.work)
        
        // Complete Work
        for _ in 1...10 { viewModel.tick() }
        viewModel.tick()
        
        XCTAssertEqual(viewModel.phase, .coolDown)
        XCTAssertEqual(viewModel.timeRemaining, 5)
    }
    
    func testCoolDownToFinish() {
        // Config to reach CoolDown immediately after Work
        config = TabataConfiguration(sets: 1, rounds: 1, warmUpTime: 0, workTime: 0, restTime: 0, coolDownTime: 5)
        viewModel.start(config: config)
        
        // Manually force CoolDown for speed (or rely on logic if times are 0)
        // But let's use the helper to be safe
        advanceToPhase(.coolDown)
        
        // Complete CoolDown
        for _ in 1...5 { viewModel.tick() }
        viewModel.tick()
        
        // Old assertion: XCTAssertEqual(viewModel.phase, .idle)
        // New assertion: The phase remains in coolDown (or last state) but isFinished flag is true.
        XCTAssertTrue(viewModel.isFinished)
        XCTAssertFalse(viewModel.isActive)
    }
    
    // MARK: - Helper
    
    private func advanceToPhase(_ targetPhase: BoxedWorkoutPhase) {
        // Safety limit to prevent infinite loops
        var ticks = 0
        while viewModel.phase != targetPhase.phase && ticks < 1000 {
            viewModel.tick()
            ticks += 1
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
