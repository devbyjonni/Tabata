//
//  StartViewModelTests.swift
//  TabataTests
//
//  Created by Jonni Åkesson on 2026-01-12.
//

import XCTest

@testable import Tabata

final class StartViewModelTests: XCTestCase {

    var viewModel: StartViewModel!
    var config: TabataConfiguration!
    
    override func setUp() {
        super.setUp()
        viewModel = StartViewModel()
        config = TabataConfiguration()
    }
    
    override func tearDown() {
        viewModel = nil
        config = nil
        super.tearDown()
    }

    func testCalculateTotalDuration() throws {
        // Given
        // Setup a known state
        config.warmUpTime = 10
        config.coolDownTime = 10
        config.workTime = 20
        config.restTime = 10
        
        // 2 Sets, 3 Rounds
        config.sets = 2
        config.rounds = 3
        
        // When
        // Calculation:
        // Cycle = Work(20) + Rest(10) = 30
        // Total Cycle = Sets(2) * Rounds(3) * Cycle(30) = 180
        // Total = WarmUp(10) + Total Cycle(180) + CoolDown(10) = 200
        let totalDuration = viewModel.calculateTotalDuration(configurations: [config])
        
        // Then
        XCTAssertEqual(totalDuration, 200, "Total duration calculation is incorrect")
    }
    
    func testUpdateSets() {
        // Given
        config.sets = 2
        
        // When: Increment
        viewModel.updateSets(by: 1, configurations: [config])
        XCTAssertEqual(config.sets, 3)
        
        // When: Decrement
        viewModel.updateSets(by: -1, configurations: [config])
        XCTAssertEqual(config.sets, 2)
        
        // When: Boundary Check (Minimum 1)
        viewModel.updateSets(by: -5, configurations: [config])
        XCTAssertEqual(config.sets, 1, "Sets should not go below 1")
        
        // When: Boundary Check (Maximum 10)
        config.sets = 9
        viewModel.updateSets(by: 2, configurations: [config])
        XCTAssertEqual(config.sets, 10, "Sets should not go above 10")
    }
    
    func testUpdateRounds() {
        // Given
        config.rounds = 5
        
        // When: Increment
        viewModel.updateRounds(by: 1, configurations: [config])
        XCTAssertEqual(config.rounds, 6)
        
        // When: Decrement
        viewModel.updateRounds(by: -1, configurations: [config])
        XCTAssertEqual(config.rounds, 5)
        
        // When: Boundary Check (Minimum 1)
        viewModel.updateRounds(by: -10, configurations: [config])
        XCTAssertEqual(config.rounds, 1, "Rounds should not go below 1")
        
        // When: Boundary Check (Maximum 10)
        config.rounds = 9
        viewModel.updateRounds(by: 2, configurations: [config])
        XCTAssertEqual(config.rounds, 10, "Rounds should not go above 10")
    }
    
    func testAdjustTime() {
        // Given
        config.workTime = 10
        
        // When: Increment
        viewModel.adjustTime(for: .work, by: 10, configurations: [config])
        XCTAssertEqual(config.workTime, 20)
        
        // When: Decrement
        viewModel.adjustTime(for: .work, by: -10, configurations: [config])
        XCTAssertEqual(config.workTime, 10)
        
        // When: Boundary Check (Minimum 0)
        viewModel.adjustTime(for: .work, by: -20, configurations: [config])
        XCTAssertEqual(config.workTime, 0, "Time should not go below 0")
        
        // Check other phases
        config.restTime = 5
        viewModel.adjustTime(for: .rest, by: -10, configurations: [config])
        XCTAssertEqual(config.restTime, 0, "Rest time should not go below 0")
    }
    
    func testAdjustTimeUpperBound() {
        // Given
        config.workTime = 590 // Near limit
        
        // When: Increment by 20 (should hit cap)
        viewModel.adjustTime(for: .work, by: 20, configurations: [config])
        XCTAssertEqual(config.workTime, 600, "Time should restrict to 600 seconds (10 minutes)")
        
        // When: Increment again (should stay at cap)
        viewModel.adjustTime(for: .work, by: 10, configurations: [config])
        XCTAssertEqual(config.workTime, 600, "Time should stay at 600")
    }
}
