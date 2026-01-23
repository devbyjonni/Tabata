# Tabata Pro ⏱️

A clean and simple Tabata timer for iOS, built for High-Intensity Interval Training.

<p align="center">
<img src="screenshots/showcase.png" width="100%" alt="Tabata Pro App Screenshot" />
</p>

## Features

* **Customizable Intervals**: Set your own Warmup, Work, Rest, and Cool Down times.
* **Voice Guide**: Audio cues tell you when to work and when to rest.
* **Haptics**: Vibration feedback for a tactile experience.
* **History**: Tracks your completed workouts automatically using SwiftData.
* **Dark Mode**: Optimized for OLED displays and gym environments.

## Technical Focus

* **Accuracy**: Uses `ContinuousClock` to ensure the timer remains scientifically accurate, preventing temporal drift during long sessions.
* **Fluidity**: Leverages `TimelineView` to synchronize the UI with the display's native refresh rate for smooth animations.
* **Safety**: Built with **Swift 6** strict concurrency to ensure thread safety across the entire application.

## Tech Stack

* **Swift 6**
* **SwiftUI**
* **SwiftData**
* **AVFoundation**

## State Management

* **isActive**: Controls the timer run loop.
* **phase**: Manages transitions (Warmup, Work, Rest).
* **timeRemaining**: High-precision countdown.
* **isFinished**: Workout completion state.

## Requirements

* **Xcode 16.0+**
* **iOS 17.0+**

## License

Created by **Jonni Åkesson**.

Open for educational and portfolio use.

---