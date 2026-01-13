//
//  StartView.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-12.
//

import SwiftUI
import SwiftData
internal import Combine

// MARK: Start View
struct StartView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var configurations: [TabataConfiguration]
    
    @State private var showWorkout = false
    @State private var showDone = false
    @State private var workoutCompleted = false
    
    var body: some View {
        VStack(spacing: 2) {
            NavbarView(
                title: "Start",
                leftIcon: Icons.stats.rawValue,
                rightIcon: Icons.settings.rawValue,
                leftAction: { print("Stats tapped") },
                rightAction: { print("Settings tapped") }
            )
            ScrollView {
                VStack(spacing: 2) {
                    TimerTextView()
                    SetsAndRoundsView()
                    SoundButton(icon: Icons.speaker.rawValue)
                    TabataTimersView()
                    Spacer()
                }
                .padding(.horizontal)
                
            }
        }
        .overlay(alignment: .bottom) {
            StartButton(icon: Icons.play.rawValue) {
                workoutCompleted = false
                showWorkout = true
            }
        }
        .fullScreenCover(isPresented: $showWorkout, onDismiss: {
            if workoutCompleted {
                // Slight delay to allow dismissal animation to finish
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    showDone = true
                }
            }
        }) {
            WorkoutView(completed: $workoutCompleted)
        }
        .fullScreenCover(isPresented: $showDone) {
            DoneView(action: {
                showDone = false
            })
        }
        .onAppear {
            if configurations.isEmpty {
                let newSettings = TabataConfiguration()
                modelContext.insert(newSettings)
            }
        }
    }
}

// MARK: Start Button
struct StartButton: View {
    let icon: String
    var action: () -> Void = {}
    
    var body: some View {
        Button(action: {
            HapticManager.shared.play(.medium)
            action()
        }) {
            ZStack {
                Circle()
                    .frame(width: 100, height: 100)
                Image(systemName: icon)
                    .font(.system(size: 44))
                    .foregroundColor(.white)
            }
        }
        .background(.gray.opacity(0.3)) // Debug
    }
}

// MARK: Navbar View
struct NavbarView: View {
    let title: String
    let leftIcon: String
    let rightIcon: String
    var leftAction: () -> Void = {}
    var rightAction: () -> Void = {}
    
    var body: some View {
        HStack {
            NavbarButton(icon: leftIcon, action: leftAction)
            Spacer()
            Text(title)
                .font(.largeTitle)
            Spacer()
            NavbarButton(icon: rightIcon, action: rightAction)
        }
        .background(.gray.opacity(0.3)) // Debug
    }
}

struct NavbarButton: View {
    let icon: String
    var action: () -> Void = {}
    
    var body: some View {
        VStack {
            Button(action: {
                HapticManager.shared.play(.light)
                action()
            }) {
                Image(systemName: icon)
                    .frame(width: 50, height: 50)
            }
        }
        .background(.gray.opacity(0.3)) // Debug
    }
}

// MARK: Timer Text View
struct TimerTextView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var configurations: [TabataConfiguration]
    
    private var viewModel: StartViewModel = StartViewModel()
    
    var body: some View {
        VStack {
            Text(viewModel.calculateTotalDuration(configurations: configurations).formatTime())
                .font(.largeTitle)
            Text("Minutes Total")
                .font(.caption)
        }
        .frame(height: 200)
        .frame(maxWidth: .infinity)
        .background(.gray.opacity(0.3)) // Debug
    }
}

// MARK: Sets And Rounds View
struct SetsAndRoundsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var configurations: [TabataConfiguration]
    
    private var viewModel: StartViewModel = StartViewModel()
    
    var body: some View {
        HStack {
            // Sets
            HStack() {
                SetAndRoundButton(icon: Icons.minus.rawValue) {
                    viewModel.updateSets(by: -1, configurations: configurations)
                }
                Text("\(configurations.first?.sets ?? 0)")
                    .font(.largeTitle)
                SetAndRoundButton(icon: Icons.plus.rawValue) {
                    viewModel.updateSets(by: 1, configurations: configurations)
                }
            }
            Spacer()
            // Rounds
            HStack() {
                SetAndRoundButton(icon: Icons.minus.rawValue) {
                    viewModel.updateRounds(by: -1, configurations: configurations)
                }
                Text("\(configurations.first?.rounds ?? 0)")
                    .font(.largeTitle)
                SetAndRoundButton(icon: Icons.plus.rawValue) {
                    viewModel.updateRounds(by: 1, configurations: configurations)
                }
            }
        }
        .background(.gray.opacity(0.3)) // Debug
    }
}

// MARK: Tabata Timers View
struct TabataTimersView: View {
    var body: some View {
        VStack(spacing: 2) {
            TabataTimerView(phase: WorkoutPhase.warmUp)
                .background(.gray.opacity(0.3)) // Debug
            TabataTimerView(phase: WorkoutPhase.work)
                .background(.gray.opacity(0.3)) // Debug
            TabataTimerView(phase: WorkoutPhase.rest)
                .background(.gray.opacity(0.3)) // Debug
            TabataTimerView(phase: WorkoutPhase.coolDown)
                .background(.gray.opacity(0.3)) // Debug
        }
    }
}

struct TabataTimerView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var configurations: [TabataConfiguration]
    
    private let viewModel: StartViewModel = StartViewModel()
    
    let phase: WorkoutPhase
    
    var body: some View {
        HStack {
            TabataTimerButton(icon: Icons.minus.rawValue) {
                viewModel.adjustTime(for: phase, by: -10, configurations: configurations)
            }
            Spacer()
            VStack {
                Text(time(for: phase))
                    .font(.largeTitle)
                Text(phase.rawValue.uppercased())
                    .font(.callout)
            }
            Spacer()
            TabataTimerButton(icon: Icons.plus.rawValue) {
                viewModel.adjustTime(for: phase, by: 10, configurations: configurations)
            }
        }
    }
    
    private func time(for phase: WorkoutPhase) -> String {
        guard let configuration = configurations.first else { return "00:00" }
        
        let time: Double
        
        switch phase {
        case .warmUp: time = configuration.warmUpTime
        case .work: time = configuration.workTime
        case .rest: time = configuration.restTime
        case .coolDown: time = configuration.coolDownTime
        case .idle: time = 0
        }
        
        return time.formatTime()
    }
}

// MARK: Set And Round Button
struct SetAndRoundButton: View {
    let icon: String
    var action: () -> Void = {}
    
    var body: some View {
        VStack {
            Button(action: {
                HapticManager.shared.play(.light)
                action()
            }) {
                Image(systemName: icon)
                    .frame(width: 50, height: 50)
            }
        }
        .background(.gray.opacity(0.3)) // Debug
    }
}

// MARK: Sound Button
struct SoundButton: View {
    let icon: String
    var action: () -> Void = {}
    
    var body: some View {
        VStack {
            Button(action: {
                HapticManager.shared.play(.light)
                action()
            }) {
                Image(systemName: icon)
                    .frame(width: 50, height: 50)
            }
        }
        .background(.gray.opacity(0.3)) // Debug
    }
}

// MARK: Tabata Timer Button
struct TabataTimerButton: View {
    let icon: String
    var action: () -> Void = {}
    
    var body: some View {
        VStack {
            Button(action: {
                HapticManager.shared.play(.light)
                action()
            }) {
                Image(systemName: icon)
                    .frame(width: 50, height: 50)
            }
        }
        .background(.gray.opacity(0.3)) // Debug
    }
}

// MARK: Workout View
struct WorkoutView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var configurations: [TabataConfiguration]
    @Binding var completed: Bool
    
    @State private var viewModel = WorkoutViewModel()
    @State private var timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 2) {
            NavbarView(
                title: viewModel.isFinished ? "Done" : "Workout",
                leftIcon: Icons.xmark.rawValue,
                rightIcon: Icons.speaker.rawValue,
                leftAction: {
                    viewModel.stop()
                    dismiss()
                },
                rightAction: {
                    print("Speaker tapped")
                }
            )
            
            VStack(spacing: 2) {
                
                Spacer()
                
                PhaseTitleView(phase: viewModel.phase)
                
                Spacer()
                
                WorkoutTimerView(viewModel: viewModel)
                
                Spacer()
                
                WorkoutStatsView(viewModel: viewModel)
                
                Spacer()
                
                WorkoutControlsView(viewModel: viewModel, dismissAction: {
                    dismiss()
                })
                
                Spacer()
            }
            .padding()
            .background(.gray.opacity(0.3)) // Debug
        }
        .onAppear {
            if let config = configurations.first {
                // Initialize UI immediately
                viewModel.setup(config: config)
                
                // Delay start to allow view transition to complete
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.65) {
                    viewModel.play()
                }
            }
        }
        .onReceive(timer) { _ in
            viewModel.tick()
        }
        .onChange(of: viewModel.isFinished) { _, newValue in
            if newValue {
                completed = true
                dismiss() // Determine done, dismiss view
            }
        }
    }
}

// MARK: Workout Timer View
struct WorkoutTimerView: View {
    var viewModel: WorkoutViewModel
    
    var body: some View {
        ZStack {
            // Background Circle
            Circle()
                .stroke(lineWidth: 20)
                .opacity(0.3)
                .foregroundColor(.gray)
            
            // Progress Circle
            Circle()
                .trim(from: 0.0, to: viewModel.progress)
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                .foregroundColor(.blue)
                .rotationEffect(Angle(degrees: 270.0))
            
            // Time Text
            Text(viewModel.timeRemaining.formatTime())
                .font(.system(size: 80, weight: .bold)) // Slightly smaller to fit
                .monospacedDigit()
        }
        .padding()
        .background(.gray.opacity(0.3)) // Debug
    }
}

// MARK: Workout Stats View
struct WorkoutStatsView: View {
    var viewModel: WorkoutViewModel
    
    var body: some View {
        HStack {
            Spacer()
            StatItemView(title: "Sets", current: viewModel.currentSet, total: viewModel.totalSets)
            Spacer()
            StatItemView(title: "Rounds", current: viewModel.currentRound, total: viewModel.totalRounds)
            Spacer()
        }
        .background(.gray.opacity(0.3)) // Debug
    }
}

// MARK: Stat Item View
struct StatItemView: View {
    let title: String
    let current: Int
    let total: Int
    
    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text("\(current) of \(total)")
                .font(.title2)
                .fontWeight(.bold)
                .monospacedDigit()
        }
    }
}

// MARK: Phase Title View
struct PhaseTitleView: View {
    let phase: WorkoutPhase
    
    var body: some View {
        HStack {
            Text(phase.rawValue.uppercased())
                .font(.system(size: 40, weight: .bold))
        }
        .background(.gray.opacity(0.3)) // Debug
    }
}

// MARK: Done View
struct DoneView: View {
    var action: () -> Void = {}
    
    var body: some View {
        VStack(spacing: 20) {
            
            NavbarView(
                title: "Done",
                leftIcon: Icons.xmark.rawValue,
                rightIcon: Icons.share.rawValue,
                leftAction: { print("Xmark tapped") },
                rightAction: { print("Share tapped") }
            )
            
            Text("WORKOUT COMPLETE!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Button(action: {
                HapticManager.shared.play(.medium)
                action()
            }) {
                Text("DONE")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
    }
}

// MARK: Workout Controls View
struct WorkoutControlsView: View {
    @Bindable var viewModel: WorkoutViewModel
    var dismissAction: () -> Void
    
    var body: some View {
        HStack(spacing: 60) {
            // Stop
            Button(action: {
                HapticManager.shared.play(.medium)
                viewModel.stop()
                dismissAction()
            }) {
                Image(systemName: Icons.stop.rawValue)
                    .font(.system(size: 30))
                    .foregroundColor(.secondary)
            }
            
            // Play/Pause
            Button(action: {
                HapticManager.shared.play(.medium)
                if viewModel.isActive {
                    viewModel.pause()
                } else {
                    viewModel.play()
                }
            }) {
                Image(systemName: viewModel.isActive ? Icons.pause.rawValue : Icons.play.rawValue)
                    .font(.system(size: 60))
                    .foregroundColor(.primary)
            }
            
            // Skip
            Button(action: {
                HapticManager.shared.play(.light)
                viewModel.skip()
            }) {
                Image(systemName: Icons.skip.rawValue)
                    .font(.system(size: 30))
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical)
        .background(.gray.opacity(0.3)) // Debug
    }
}

// MARK: Preview
#Preview {
    StartView()
        .modelContainer(for: TabataConfiguration.self, inMemory: true)
}
