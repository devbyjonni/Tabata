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
    @State private var showCompletion = false
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
                    ControlButton(icon: Icons.speaker.rawValue, backgroundColor: .clear, foregroundColor: .primary, size: 50, iconSize: 20)
                    TabataTimersView()
                    Spacer()
                }
                .padding(.horizontal)
                
            }
        }
        .overlay(alignment: .bottom) {
            ControlButton(
                icon: Icons.play.rawValue,
                backgroundColor: .green,
                foregroundColor: .white,
                size: 100,
                iconSize: 50
            ) {
                workoutCompleted = false
                showWorkout = true
            }
        }
        .fullScreenCover(isPresented: $showWorkout, onDismiss: {
            if workoutCompleted {
                // Slight delay to allow dismissal animation to finish
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    showCompletion = true
                }
            }
        }) {
            WorkoutView(completed: $workoutCompleted)
        }
        .fullScreenCover(isPresented: $showCompletion) {
            CompletedView(action: {
                showCompletion = false
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
                .font(.system(size: 34, weight: .bold, design: .rounded))
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
        ControlButton(
            icon: icon,
            backgroundColor: .clear,
            foregroundColor: .primary,
            size: 50,
            iconSize: 20
        ) {
            action()
        }
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
                .font(.system(size: 34, weight: .bold, design: .rounded))
            Text("Minutes Total")
                .font(.system(size: 14, weight: .medium, design: .rounded))
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
            VStack {
                HStack() {
                    ControlButton(icon: Icons.minus.rawValue, backgroundColor: .gray.opacity(0.2), foregroundColor: .primary, size: 50, iconSize: 20) {
                        viewModel.updateSets(by: -1, configurations: configurations)
                    }
                    Text("\(configurations.first?.sets ?? 0)")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .frame(width: 60)
                        .multilineTextAlignment(.center)
                    
                    ControlButton(icon: Icons.plus.rawValue, backgroundColor: .gray.opacity(0.2), foregroundColor: .primary, size: 50, iconSize: 20) {
                        viewModel.updateSets(by: 1, configurations: configurations)
                    }
                    
                }
                Text("Sets")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
            }
            Spacer()
            // Rounds
            VStack {
                HStack() {
                    ControlButton(icon: Icons.minus.rawValue, backgroundColor: .gray.opacity(0.2), foregroundColor: .primary, size: 50, iconSize: 20) {
                        viewModel.updateRounds(by: -1, configurations: configurations)
                    }
                    Text("\(configurations.first?.rounds ?? 0)")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .frame(width: 60)
                        .multilineTextAlignment(.center)
                    
                    ControlButton(icon: Icons.plus.rawValue, backgroundColor: .gray.opacity(0.2), foregroundColor: .primary, size: 50, iconSize: 20) {
                        viewModel.updateRounds(by: 1, configurations: configurations)
                    }
                }
                Text("Rounds")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
            }
        }
        .background(.gray.opacity(0.3)) // Debug
    }
}

// MARK: Tabata Timers View
struct TabataTimersView: View {
    var body: some View {
        VStack(spacing: 2) {
            TabataTimerView(phase: WorkoutPhase.warmUp, icon: Icons.warmUp.rawValue)
                .background(.gray.opacity(0.3)) // Debug
            TabataTimerView(phase: WorkoutPhase.work, icon: Icons.work.rawValue)
                .background(.gray.opacity(0.3)) // Debug
            TabataTimerView(phase: WorkoutPhase.rest, icon: Icons.rest.rawValue)
                .background(.gray.opacity(0.3)) // Debug
            TabataTimerView(phase: WorkoutPhase.coolDown, icon: Icons.cooldown.rawValue)
                .background(.gray.opacity(0.3)) // Debug
        }
    }
}

struct TabataTimerView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var configurations: [TabataConfiguration]
    
    private let viewModel: StartViewModel = StartViewModel()
    
    let phase: WorkoutPhase
    
    let icon: String
    
    var body: some View {
        HStack {
            ControlButton(icon: Icons.minus.rawValue, backgroundColor: .gray.opacity(0.2), foregroundColor: .primary, size: 50, iconSize: 20) {
                viewModel.adjustTime(for: phase, by: -10, configurations: configurations)
            }
            Spacer()
            VStack {
                Text(time(for: phase))
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                HStack {
                    Text(phase.rawValue.uppercased())
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                    Image(systemName: icon)
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
            ControlButton(icon: Icons.plus.rawValue, backgroundColor: .gray.opacity(0.2), foregroundColor: .primary, size: 50, iconSize: 20) {
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
                .font(.system(size: 80, weight: .black, design: .rounded)) // Slightly smaller to fit
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
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(.secondary)
            Text("\(current) of \(total)")
                .font(.system(size: 22, weight: .bold, design: .rounded))
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
                .font(.system(size: 40, weight: .black, design: .rounded))
        }
        .background(.gray.opacity(0.3)) // Debug
    }
}

// MARK: Completed View
struct CompletedView: View {
    var action: () -> Void = {}
    
    var body: some View {
        VStack(spacing: 2) {
            NavbarView(
                title: "Completed",
                leftIcon: Icons.xmark.rawValue,
                rightIcon: Icons.share.rawValue,
                leftAction: { print("Xmark tapped") },
                rightAction: { print("Share tapped") }
            )
            Spacer()
            Text("WORKOUT COMPLETED!")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            Spacer()
            Button(action: {
                HapticManager.shared.play(.medium)
                action()
            }) {
                Text("DONE")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        Spacer()
    }
}

// MARK: Workout Controls View
struct WorkoutControlsView: View {
    @Bindable var viewModel: WorkoutViewModel
    var dismissAction: () -> Void
    
    var body: some View {
        HStack(spacing: 40) {
            // Stop
            ControlButton(
                icon: Icons.stop.rawValue,
                backgroundColor: .red.opacity(0.8),
                foregroundColor: .white,
                size: 60,
                iconSize: 24
            ) {
                viewModel.stop()
                dismissAction()
            }
            
            // Play/Pause
            ControlButton(
                icon: viewModel.isActive ? Icons.pause.rawValue : Icons.play.rawValue,
                backgroundColor: viewModel.isActive ? .orange : .green,
                foregroundColor: .white,
                size: 100,
                iconSize: 50
            ) {
                if viewModel.isActive {
                    viewModel.pause()
                } else {
                    viewModel.play()
                }
            }
            
            // Skip
            ControlButton(
                icon: Icons.skip.rawValue,
                backgroundColor: .blue.opacity(0.8),
                foregroundColor: .white,
                size: 60,
                iconSize: 24
            ) {
                viewModel.skip()
            }
        }
        .padding(.vertical)
    }
}

// MARK: Control Button
struct ControlButton: View {
    let icon: String
    let backgroundColor: Color
    let foregroundColor: Color
    var size: CGFloat = 80
    var iconSize: CGFloat = 30
    var borderColor: Color = .clear
    var borderWidth: CGFloat = 0
    var action: () -> Void = {}
    
    var body: some View {
        Button(action: {
            HapticManager.shared.play(.medium)
            action()
        }) {
            ZStack {
                Circle()
                    .fill(backgroundColor)
                    .overlay(
                        Circle()
                            .stroke(borderColor, lineWidth: borderWidth)
                    )
                    .frame(width: size, height: size)
                Image(systemName: icon)
                    .font(.system(size: iconSize, weight: .bold, design: .rounded))
                    .foregroundColor(foregroundColor)
            }
        }
    }
}

// MARK: Preview
#Preview {
    StartView()
        .modelContainer(for: TabataConfiguration.self, inMemory: true)
}
