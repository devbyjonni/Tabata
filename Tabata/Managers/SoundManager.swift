//
//  SoundManager.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-13.
//

import Foundation
import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    
    var isSoundEnabled: Bool = true
    var isVoiceGuideEnabled: Bool = true
    var volume: Double = 1.0
    var countdownDuration: Int = 3
    
    private let audioPlayerService: AudioPlayerService
    private let speechService: SpeechSynthesizerService
    
    // Internal init for testing (allows injecting mocks)
    init(
        audioPlayerService: AudioPlayerService = AVAudioPlayerService(),
        speechService: SpeechSynthesizerService = AVSpeechSynthesizerService()
    ) {
        self.audioPlayerService = audioPlayerService
        self.speechService = speechService
    }
    
    func playBeep() {
        guard isSoundEnabled else { return }
        
        guard let url = Bundle.main.url(forResource: "beep", withExtension: "wav") else {
            print("SoundManager: beep.wav not found")
            return
        }
        
        audioPlayerService.play(url: url, volume: Float(volume))
    }
    
    func speak(_ text: String) {
        guard isSoundEnabled && isVoiceGuideEnabled else { return }
        speechService.speak(text, volume: Float(volume))
    }
}

// MARK: - Audio Protocols

/// Protocol for playing audio files (e.g. beeps)
protocol AudioPlayerService {
    func play(url: URL, volume: Float)
}

/// Protocol for synthesizing speech
protocol SpeechSynthesizerService {
    func speak(_ text: String, volume: Float)
}

// MARK: - Concrete Implementations

/// Real implementation using AVAudioPlayer
class AVAudioPlayerService: AudioPlayerService {
    private var audioPlayer: AVAudioPlayer?
    
    func play(url: URL, volume: Float) {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.volume = volume
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("AudioPlayerService: Error playing sound - \(error.localizedDescription)")
        }
    }
}

/// Real implementation using AVSpeechSynthesizer
class AVSpeechSynthesizerService: SpeechSynthesizerService {
    private let synthesizer = AVSpeechSynthesizer()
    
    func speak(_ text: String, volume: Float) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        utterance.volume = volume
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .duckOthers)
            try AVAudioSession.sharedInstance().setActive(true)
            synthesizer.speak(utterance)
        } catch {
            print("SpeechSynthesizerService: Error speaking - \(error.localizedDescription)")
        }
    }
}
