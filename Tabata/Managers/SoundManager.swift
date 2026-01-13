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
    
    private var audioPlayer: AVAudioPlayer?
    
    private init() {}
    
    func playBeep() {
        guard let url = Bundle.main.url(forResource: "beep", withExtension: "wav") else {
            print("SoundManager: beep.wav not found")
            return
        }
        
        do {
            // Configure session for playback even if silent mode is on
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("SoundManager: Error playing sound - \(error.localizedDescription)")
        }
    }
    
    private let synthesizer = AVSpeechSynthesizer()
    
    func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .duckOthers)
            try AVAudioSession.sharedInstance().setActive(true)
            synthesizer.speak(utterance)
        } catch {
            print("SoundManager: Error speaking - \(error.localizedDescription)")
        }
    }
}
