//
//  SettingsView.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-13.
//

import SwiftUI
import SwiftData

/// App settings screen.
/// Allows configuration of globally applied preferences like Dark Mode.
/// App settings screen.
/// Allows configuration of audio, feedback, and data management.
struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var settings: [TabataSettings]
    @Query private var history: [CompletedWorkout]
    
    @State private var isResetConfirmPresented = false
    
    var body: some View {
        ZStack {
            Color.slate900.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                NavbarView(
                    title: "Settings",
                    leftIcon: Icons.xmark.rawValue,
                    rightIcon: "",
                    leftAction: { dismiss() },
                    rightAction: {}
                )
                .padding(.bottom, 20)
                
                ScrollView {
                    VStack(spacing: 32) {
                        if let currentSettings = settings.first {
                            audioFeedbackSection(settings: currentSettings)
                            dataSection
                            aboutSection
                            footerView
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Sections
    
    private func audioFeedbackSection(settings: TabataSettings) -> some View {
        @Bindable var settings = settings
        
        return VStack(alignment: .leading, spacing: 12) {
            sectionHeader("AUDIO & FEEDBACK")
            
            VStack(spacing: 0) {
                // Voice Guide
                SettingsRow(
                    icon: "waveform.circle.fill",
                    iconColor: Theme.primary,
                    iconBg: Theme.primary.opacity(0.1),
                    title: "Voice Guide",
                    isOn: Binding(
                        get: { settings.isVoiceGuideEnabled },
                        set: { newValue in
                            settings.isVoiceGuideEnabled = newValue
                            SoundManager.shared.isVoiceGuideEnabled = newValue
                            
                            // Ensure master sound is on if voice is requested
                            if newValue {
                                if !settings.isSoundEnabled {
                                    settings.isSoundEnabled = true
                                    SoundManager.shared.isSoundEnabled = true
                                }
                                if settings.volume == 0 {
                                    settings.volume = 0.5
                                    SoundManager.shared.volume = 0.5
                                }
                            }
                        }
                    )
                )
                .onChange(of: settings.isVoiceGuideEnabled) { _, new in
                    if new { SoundManager.shared.speak("Voice Guide On") }
                }
                
                Divider().padding(.leading, 70).opacity(0.5)
                
                // Haptic Feedback
                SettingsRow(
                    icon: "iphone.radiowaves.left.and.right",
                    iconColor: Theme.primary,
                    iconBg: Theme.primary.opacity(0.1),
                    title: "Haptic Feedback",
                    isOn: Binding(
                        get: { settings.isHapticsEnabled },
                        set: {
                            settings.isHapticsEnabled = $0
                            HapticManager.shared.isHapticsEnabled = $0
                        }
                    )
                )
                
                Divider().padding(.leading, 70).opacity(0.5)
                
                // Countdown Beep
                SettingsRow(
                    icon: "timer",
                    iconColor: Theme.primary,
                    iconBg: Theme.primary.opacity(0.1),
                    title: "Countdown Beep (3s)",
                    isOn: Binding(
                        get: { settings.isCountdownEnabled },
                        set: { settings.isCountdownEnabled = $0 }
                    )
                )
                
                Divider().padding(.leading, 70).opacity(0.5)
                
                // App Volume
                SettingsSliderRow(
                    icon: "speaker.wave.3.fill",
                    iconColor: Theme.primary,
                    iconBg: Theme.primary.opacity(0.1),
                    title: "App Volume",
                    value: Binding(
                        get: { settings.isSoundEnabled ? settings.volume : 0 },
                        set: { newValue in
                            settings.volume = newValue
                            SoundManager.shared.volume = newValue
                            
                            if newValue > 0 {
                                settings.isSoundEnabled = true
                                SoundManager.shared.isSoundEnabled = true
                            } else {
                                settings.isSoundEnabled = false
                                SoundManager.shared.isSoundEnabled = false
                            }
                        }
                    )
                )
            }
            .background(Color.slate800)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(Color.slate700, lineWidth: 1)
            )
        }
    }
    
    private var dataSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("DATA")
            
            Button(action: {
                HapticManager.shared.notification(.warning)
                isResetConfirmPresented = true
            }) {
                HStack(spacing: 16) {
                    Image(systemName: "trash.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(Color.red)
                        .frame(width: 40, height: 40)
                        .background(Color.red.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Reset History")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.red)
                        
                        Text("This action cannot be undone")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundStyle(Color.slate400)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color.slate600)
                }
                .padding(20)
                .background(Color.slate800)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(Color.slate700, lineWidth: 1)
                )
            }
            .alert("Reset History?", isPresented: $isResetConfirmPresented) {
                Button("Cancel", role: .cancel) { }
                Button("Delete All", role: .destructive) {
                    deleteAllHistory()
                }
            } message: {
                Text("Are you sure you want to delete all \(history.count) completed workouts? This cannot be undone.")
            }
        }
    }
    
    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("ABOUT TABATA")
            
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top, spacing: 16) {
                    Image(systemName: "info.circle.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(Theme.primary)
                        .frame(width: 40)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("What is Tabata?")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                        
                        Text("Tabata is a high-intensity interval training (HIIT) protocol: 20 seconds of ultra-intense exercise followed by 10 seconds of rest, repeated continuously for 4 minutes (8 rounds).")
                            .font(.system(size: 15, weight: .regular, design: .rounded))
                            .foregroundStyle(Color.slate400)
                            .lineSpacing(4)
                    }
                }
                
                Divider().opacity(0.5)
                
                HStack(alignment: .top, spacing: 16) {
                    Image(systemName: "heart.text.square.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(Color.red)
                        .frame(width: 40)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Benefits")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                        
                        Text("• Improves aerobic & anaerobic capacity\n• Boosts metabolism\n• Extremely time-efficient")
                            .font(.system(size: 15, weight: .regular, design: .rounded))
                            .foregroundStyle(Color.slate400)
                            .lineSpacing(4)
                    }
                }
            }
            .padding(20)
            .background(Color.slate800)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(Color.slate700, lineWidth: 1)
            )
        }
    }
    
    private var footerView: some View {
        VStack(spacing: 16) {
            Text("TABATA PRO V1.0")
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .tracking(2)
                .foregroundStyle(Color.slate600)
        }
    }
    
    // MARK: - Helpers
    
    private func sectionHeader(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 14, weight: .black, design: .rounded))
            .tracking(2)
            .foregroundStyle(Color.slate500)
            .padding(.leading, 4)
    }
    
    private func deleteAllHistory() {
        HapticManager.shared.notification(.success)
        withAnimation {
            for session in history {
                modelContext.delete(session)
            }
        }
    }
}

// MARK: - Components

fileprivate struct SettingsRow: View {
    let icon: String
    let iconColor: Color
    let iconBg: Color
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(iconColor)
                .frame(width: 40, height: 40)
                .background(iconBg)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            
            Text(title)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(Theme.primary)
                .onChange(of: isOn) { _, _ in
                    HapticManager.shared.selection()
                }
        }
        .padding(20)
    }
}

fileprivate struct SettingsSliderRow: View {
    let icon: String
    let iconColor: Color
    let iconBg: Color
    let title: String
    @Binding var value: Double
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(iconColor)
                    .frame(width: 40, height: 40)
                    .background(iconBg)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                
                Text(title)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                
                Spacer()
            }
            
            HStack {
                Image(systemName: "speaker.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.slate500)
                
                Slider(value: $value, in: 0...1)
                    .tint(Theme.primary)
                
                Image(systemName: "speaker.wave.3.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.slate500)
            }
            .padding(.horizontal, 4)
        }
        .padding(20)
    }
}


