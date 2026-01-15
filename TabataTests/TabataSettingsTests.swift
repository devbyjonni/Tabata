//
//  TabataSettingsTests.swift
//  TabataTests
//
//  Created by Jonni Åkesson on 2026-01-15.
//

import XCTest
@testable import Tabata

final class TabataSettingsTests: XCTestCase {

    func testDefaultValues() {
        let settings = TabataSettings()
        
        // precise assertions based on the init defaults we set
        XCTAssertTrue(settings.isSoundEnabled, "Sound should be enabled by default")
        XCTAssertTrue(settings.isCountdownEnabled, "Countdown should be enabled by default")
        XCTAssertTrue(settings.isVoiceGuideEnabled, "Voice Guide should be enabled by default")
        XCTAssertTrue(settings.isHapticsEnabled, "Haptics should be enabled by default")
        XCTAssertEqual(settings.volume, 1.0, accuracy: 0.001, "Volume should default to 1.0")
        XCTAssertEqual(settings.countdownDuration, 3, "Countdown duration should default to 3")
    }
    
    func testCustomInit() {
        let settings = TabataSettings(
            isSoundEnabled: false,
            isCountdownEnabled: false,
            isVoiceGuideEnabled: false,
            isHapticsEnabled: false,
            volume: 0.5,
            countdownDuration: 10
        )
        
        XCTAssertFalse(settings.isSoundEnabled)
        XCTAssertFalse(settings.isCountdownEnabled)
        XCTAssertFalse(settings.isVoiceGuideEnabled)
        XCTAssertFalse(settings.isHapticsEnabled)
        XCTAssertEqual(settings.volume, 0.5, accuracy: 0.001)
        XCTAssertEqual(settings.countdownDuration, 10)
    }
}
