# Tabata Pro ⏱️

**A professional-grade HIIT timer built with modern Swift, SwiftData, and a focus on architectural testability.**

Tabata Pro is a native iOS application designed for High-Intensity Interval Training. It combines a premium, dark-mode aesthetic with a robust engineering foundation, leveraging **SwiftData** for persistence and a **Protocol-Oriented** architecture for reliable unit testing.

<p align="center">
<img src="screenshots/showcase.png" width="100%" alt="Tabata Pro App Screenshot" />
</p>

---

## 🛠 Engineering Highlights

### 1. Drift-Free Temporal Engine

* **High-Precision Timing**: Utilizes `ContinuousClock` to calculate precise temporal deltas (`now - lastTime`) rather than accumulating error-prone relative ticks. This ensures the workout duration remains scientifically accurate to the millisecond, even during system lag or thermal throttling.
* **Recursive Phase Processing**: The engine implements a `while` loop to handle "overshoot" time. If a system delay exceeds the remaining phase time, the engine mathematically carries over the remaining delta to the next phase, preserving state integrity across the entire workout.

### 2. Advanced UI Synchronization

* **Interpolated Rendering**: Leverages `TimelineView(.animation)` to synchronize UI updates with the display's native refresh rate (up to 120Hz on ProMotion).
* **Hardware-Accelerated Fluidity**: By applying linear interpolation via `.animation` in the View layer, the Core Animation render server handles "in-between" frames. This results in perfectly smooth motion while maintaining low CPU overhead.

### 3. Protocol-Oriented Audio Architecture

To ensure audio and speech logic is fully testable, the system utilizes a decoupled architecture via **Dependency Injection**:

* **Abstraction Layer**: `SoundManager` interacts with abstract protocols (`AudioPlayerService`, `SpeechSynthesizerService`) rather than concrete system classes.
* **Reliable Testing**: This decoupling allows system dependencies to be swapped with **Mocks** during unit testing. We can verify that the correct audio cues are triggered at exact intervals in CI/CD pipelines without playing actual sound.

---

## 🏗 Tech Stack & Requirements

| Category | Technology | Grade 5 Senior Implementation |
| --- | --- | --- |
| **Language** | **Swift 6.2** | Strict concurrency (Data-Race Safety) and `@Observable` macros. |
| **Concurrency** | **MainActor** | Global actor isolation for the ViewModel to ensure thread-safe UI updates. |
| **Timing** | **ContinuousClock** | Monotonic time management to eliminate "Timer Drift". |
| **UI Framework** | **SwiftUI** | `TimelineView` with interpolation for 120Hz ProMotion fluidity. |
| **Persistence** | **SwiftData** | Modern, declarative schema management via the `@Model` architecture. |

### 🖥 Requirements
* **Xcode 16.0+** (Required for Swift 6 compiler features)
* **iOS 17.0+** (Required for SwiftData and @Observable macro)
* **Physical Device**: Highly recommended to experience **Haptic Feedback** and **ProMotion (120Hz)** synchronization.

---

## 📱 Features

* **Smart Voice Guide**: Synthesized speech announces phase changes ("Work", "Rest") based on current context.
* **Thermal & Energy Optimized UI**: Utilizes high-contrast OLED black and offloads animation interpolation to the render server to minimize battery impact.
* **Haptic Feedback**: Syncs physical vibration patterns with audio cues for a tactile user experience.

---

## 📜 License

Created by **Jonni Åkesson**.
Open for educational and portfolio use.

---