import SwiftUI

struct WorkoutTimerView: View {
    var viewModel: WorkoutViewModel
    
    var body: some View {
        // TimelineView updates at the hardware's refresh rate (e.g., 120Hz on ProMotion).
        // It provides the context needed to interpolate the UI state smoothly between
        // the coarser 20Hz ticks from the ViewModel.
        TimelineView(.animation) { context in
            ZStack {
                Circle()
                    .stroke(lineWidth: 20)
                    .opacity(0.3)
                    .foregroundColor(.white)
                
                Circle()
                    .trim(from: 0.0, to: viewModel.progress)
                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .foregroundColor(.white)
                    .rotationEffect(Angle(degrees: 270.0))
                    // ANIMATION STRATEGY:
                    // The ViewModel updates `progress` at ~20Hz (every 0.05s).
                    // We use `.animation(.linear(duration: 0.05))` here to tell SwiftUI
                    // to interpolate this change over the exact duration of the tick.
                    // This creates a perfectly smooth, fluid resizing of the ring at the system's
                    // max refresh rate (60fps or 120fps), decoupled from the logic tick rate.
                    .animation(.linear(duration: 0.05), value: viewModel.progress)
                
                Text(viewModel.timeRemaining.formatTime())
                    .font(.system(size: 80, weight: .black, design: .rounded))
                    .monospacedDigit()
                    .foregroundColor(.white)
                    // This creates the smooth "fading" transition between numbers
                    .contentTransition(.numericText(value: viewModel.timeRemaining))
                    // Same linear interpolation strategy applied to the text timer.
                    .animation(.linear(duration: 0.05), value: viewModel.timeRemaining)
            }
        }
        .padding()
    }
}
