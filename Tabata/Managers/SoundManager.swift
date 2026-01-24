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
    
    /// Preloads audio resources to prevent lag on first playback.
    func prepare() {
        audioPlayerService.warmUp()
        speechService.warmUp()
    }
}

// MARK: - Audio Protocols

/// Protocol for playing audio files (e.g. beeps)
protocol AudioPlayerService {
    func play(url: URL, volume: Float)
    func warmUp()
}

/// Protocol for synthesizing speech
protocol SpeechSynthesizerService {
    func speak(_ text: String, volume: Float)
    func warmUp()
}

// MARK: - Concrete Implementations

/// Real implementation using AVAudioPlayer
class AVAudioPlayerService: AudioPlayerService {
    private var audioPlayer: AVAudioPlayer?
    private let queue = DispatchQueue(label: "com.tabata.audio.player", qos: .userInitiated)
    
    func play(url: URL, volume: Float) {
        queue.async { [weak self] in
            guard let self = self else { return }
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
                
                let player = try AVAudioPlayer(contentsOf: url)
                player.volume = volume
                player.prepareToPlay()
                player.play()
                
                // Keep reference to avoid deallocation
                self.audioPlayer = player
            } catch {
                print("AudioPlayerService: Error playing sound - \(error.localizedDescription)")
            }
        }
    }
    
    func warmUp() {
        queue.async {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            } catch {
                print("AudioPlayerService: Warmup error - \(error.localizedDescription)")
            }
        }
    }
}

/// Real implementation using AVSpeechSynthesizer
class AVSpeechSynthesizerService: SpeechSynthesizerService {
    private let synthesizer = AVSpeechSynthesizer()
    private let queue = DispatchQueue(label: "com.tabata.audio.speech", qos: .userInitiated)
    
    func speak(_ text: String, volume: Float) {
        queue.async { [weak self] in
            guard let self = self else { return }
            let utterance = AVSpeechUtterance(string: text)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            utterance.rate = 0.5
            utterance.volume = volume
            
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .duckOthers)
                try AVAudioSession.sharedInstance().setActive(true)
                self.synthesizer.speak(utterance)
            } catch {
                print("SpeechSynthesizerService: Error speaking - \(error.localizedDescription)")
            }
        }
    }
    
    func warmUp() {
        queue.async { [weak self] in
            _ = self?.synthesizer
        }
    }
}
