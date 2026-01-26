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

// MARK: - SoundManager Tests (Merged)

// MARK: - Mocks

class MockAudioPlayerService: AudioPlayerService {
    var playCalledCount = 0
    var lastPlayedURL: URL?
    var lastVolume: Float?
    
    func play(url: URL, volume: Float) {
        playCalledCount += 1
        lastPlayedURL = url
        lastVolume = volume
    }
    
    func warmUp() {
        // No-op for mock
    }
}

class MockSpeechSynthesizerService: SpeechSynthesizerService {
    var speakCalledCount = 0
    var lastSpokenText: String?
    var lastVolume: Float?
    
    func speak(_ text: String, volume: Float) {
        speakCalledCount += 1
        lastSpokenText = text
        lastVolume = volume
    }
    
    func warmUp() {
        // No-op for mock
    }
}

// MARK: - Tests

final class SoundManagerTests: XCTestCase {
    
    var soundManager: SoundManager!
    var mockAudioService: MockAudioPlayerService!
    var mockSpeechService: MockSpeechSynthesizerService!
    
    override func setUp() {
        super.setUp()
        mockAudioService = MockAudioPlayerService()
        mockSpeechService = MockSpeechSynthesizerService()
        soundManager = SoundManager(audioPlayerService: mockAudioService, speechService: mockSpeechService)
    }
    
    override func tearDown() {
        soundManager = nil
        mockAudioService = nil
        mockSpeechService = nil
        super.tearDown()
    }
    
    // MARK: - Sound (Beep) Tests
    
    func testPlayBeep_WhenEnabled_ShouldPlay() {
        // Given
        soundManager.isSoundEnabled = true
        soundManager.volume = 0.5
        
        // When
        soundManager.playBeep()
        
        // Then
        XCTAssertEqual(mockAudioService.playCalledCount, 1)
        XCTAssertEqual(mockAudioService.lastVolume, 0.5)
        XCTAssertEqual(mockAudioService.lastPlayedURL?.lastPathComponent, "beep.wav")
    }
    
    func testPlayBeep_WhenDisabled_ShouldNotPlay() {
        // Given
        soundManager.isSoundEnabled = false
        
        // When
        soundManager.playBeep()
        
        // Then
        XCTAssertEqual(mockAudioService.playCalledCount, 0)
    }
    
    // MARK: - Voice Guide Tests
    
    func testSpeak_WhenEnabled_ShouldSpeak() {
        // Given
        soundManager.isSoundEnabled = true
        soundManager.isVoiceGuideEnabled = true
        soundManager.volume = 0.8
        
        // When
        soundManager.speak("Test")
        
        // Then
        XCTAssertEqual(mockSpeechService.speakCalledCount, 1)
        XCTAssertEqual(mockSpeechService.lastSpokenText, "Test")
        XCTAssertEqual(mockSpeechService.lastVolume, 0.8)
    }
    
    func testSpeak_WhenGlobalSoundDisabled_ShouldNotSpeak() {
        // Given
        soundManager.isSoundEnabled = false
        soundManager.isVoiceGuideEnabled = true
        
        // When
        soundManager.speak("Test")
        
        // Then
        XCTAssertEqual(mockSpeechService.speakCalledCount, 0)
    }
    
    func testSpeak_WhenVoiceDisabled_ShouldNotSpeak() {
        // Given
        soundManager.isSoundEnabled = true
        soundManager.isVoiceGuideEnabled = false
        
        // When
        soundManager.speak("Test")
        
        // Then
        XCTAssertEqual(mockSpeechService.speakCalledCount, 0)
    }
}
