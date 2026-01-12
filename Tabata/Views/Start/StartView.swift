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
    
    var body: some View {
        VStack(spacing: 2) {
            NavbarView(
                title: "Tabata",
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
            
            }
        }
        .overlay(alignment: .bottom) {
            StartButton(icon: Icons.play.rawValue) {
                showWorkout = true
            }
        }
        .fullScreenCover(isPresented: $showWorkout) {
            WorkoutView()
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
    
    @State private var viewModel = WorkoutViewModel()
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 2) {
            NavbarView(
                title: viewModel.isFinished ? "DONE" : viewModel.phase.rawValue.uppercased(),
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
            
            Spacer()
            
            if viewModel.isFinished {
                DoneView(action: {
                    dismiss()
                })
            } else {
                WorkoutTimerView(viewModel: viewModel)
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            if let config = configurations.first {
                viewModel.start(config: config)
            }
        }
        .onReceive(timer) { _ in
            viewModel.tick()
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
                .animation(.linear(duration: 1.0), value: viewModel.progress)
            
            // Time Text
            Text(viewModel.timeRemaining.formatTime())
                .font(.system(size: 80, weight: .bold)) // Slightly smaller to fit
                .monospacedDigit()
        }
        .padding(40)
    }
}

// MARK: Done View
struct DoneView: View {
    var action: () -> Void = {}
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 100))
                .foregroundColor(.green)
            
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
            .padding(.horizontal, 40)
        }
    }
}

// MARK: Preview
#Preview {
    StartView()
        .modelContainer(for: TabataConfiguration.self, inMemory: true)
}
