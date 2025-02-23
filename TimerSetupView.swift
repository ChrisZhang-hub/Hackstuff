import SwiftUI

struct TimerSetupView: View {
    @Binding var weeklyStudyData: [Int] // Binding to weekly study data
    @State private var selectedHours = 0
    @State private var selectedMinutes = 0
    @State private var isTimerRunning = false
    @State private var timeRemaining = 0
    @State private var timer: Timer?
    @State private var hasStopped = false // Flag to track if the timer has already been stopped
    @State private var startTime: Date? // Track when the timer started
    @State private var isShowingTimerView = false

    let hoursRange = Array(0...24) // Extended range: 0 to 24 hours
    let minutesRange = Array(0...59)

    var body: some View {
        VStack(spacing: 20) {
            if !isTimerRunning {
                // Time Selection
                Text("Select Study Duration")
                    .font(.title)
                    .fontWeight(.bold)

                HStack {
                    // Hours Picker
                    CustomWheelPicker(selection: $selectedHours, range: hoursRange, label: "hr") // Changed to "hr"
                        .frame(width: 120, height: 250)

                    // Minutes Picker
                    CustomWheelPicker(selection: $selectedMinutes, range: minutesRange, label: "min") // Changed to "min"
                        .frame(width: 120, height: 250)
                }

                // Start Button
                Button(action: startTimer) {
                    Text("Start Timer")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                
                // Count Up Button
                Button(action: {
                    isShowingTimerView = true
                }) {
                    Text("Count Up Timer")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                
                // NavigationLink to TimerView
                NavigationLink(destination: TimerView(weeklyStudyData: $weeklyStudyData), isActive: $isShowingTimerView) {
                    EmptyView()
                }
            } else {
                // Countdown Timer
                Text("Time Remaining")
                    .font(.title)
                    .fontWeight(.bold)

                Text(timeFormatted(timeRemaining))
                    .font(.system(size: 48, weight: .bold, design: .monospaced))
                    .padding()

                Button(action: stopTimer) {
                    Text("Stop Timer")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
            }
        }
        .padding()
        .navigationTitle("Study Timer")
        .onDisappear {
            stopTimer() // Stop the timer when the view disappears
        }
    }

    // Start the timer
    private func startTimer() {
        let totalSeconds = (selectedHours * 3600) + (selectedMinutes * 60)
        timeRemaining = totalSeconds
        isTimerRunning = true
        hasStopped = false // Reset the flag when starting the timer
        startTime = Date() // Record the start time

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                stopTimer()
            }
        }
    }

    // Stop the timer and update today's study time
    private func stopTimer() {
        guard !hasStopped else { return } // Ensure the timer is only stopped once
        hasStopped = true // Mark the timer as stopped

        timer?.invalidate()
        timer = nil
        isTimerRunning = false

        // Calculate elapsed time in minutes
        if let startTime = startTime {
            let elapsedTime = Int(Date().timeIntervalSince(startTime)) / 60 // Convert to minutes
            updateStudyData(elapsedTime: elapsedTime)
        }
    }

    // Update study data with elapsed time
    private func updateStudyData(elapsedTime: Int) {
        // Update today's study time
        if !weeklyStudyData.isEmpty {
            weeklyStudyData[weeklyStudyData.count - 1] += elapsedTime // Add elapsed time to today's entry
        } else {
            weeklyStudyData.append(elapsedTime) // Add a new entry if the array is empty
        }

        // Save the updated study data to the JSON file
        saveStudyData()
    }

    // Save study data to a JSON file
    private func saveStudyData() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent("study_data.json")

        do {
            let data = try JSONEncoder().encode(weeklyStudyData)
            try data.write(to: fileURL)
            print("Study data saved successfully.")
        } catch {
            print("Failed to save study data: \(error)")
        }
    }

    // Format time as HH:MM:SS
    private func timeFormatted(_ totalSeconds: Int) -> String {
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

// Timer View
struct TimerView: View {
    @Binding var weeklyStudyData: [Int] // Binding to weekly study data
    @State private var elapsedTime: Int = 0 // Tracks elapsed time in seconds
    @State private var timer: Timer? = nil // Holds the timer object

    var body: some View {
        VStack(spacing: 20) {
            // Display the elapsed time in HH:MM:SS format
            Text("Elapsed Time: \(formatTime(elapsedTime))")
                .font(.largeTitle)
                .padding()

            // Start/Stop buttons
            HStack(spacing: 20) {
                Button(action: startTimer) {
                    Text("Start")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Button(action: resetTimer) {
                    Text("Save/Reset")
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .navigationTitle("Timer")
        .onDisappear {
            stopTimer() // Stop the timer when the view disappears
        }
    }

    // Start the timer
    private func startTimer() {
        timer?.invalidate() // Stop any existing timer
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            elapsedTime += 1 // Increment elapsed time every second
        }
    }

    // Stop the timer
    private func stopTimer() {
        timer?.invalidate() // Stop the timer
        timer = nil
    }

    // Reset the timer
    private func resetTimer() {
        stopTimer() // Stop the timer
        let elapsedMinutes = elapsedTime / 60 // Convert elapsed time to minutes
        updateStudyData(elapsedTime: elapsedMinutes) // Update study data
        elapsedTime = 0 // Reset elapsed time to 0
    }

    // Update study data with elapsed time
    private func updateStudyData(elapsedTime: Int) {
        // Update today's study time
        if !weeklyStudyData.isEmpty {
            weeklyStudyData[weeklyStudyData.count - 1] += elapsedTime // Add elapsed time to today's entry
        } else {
            weeklyStudyData.append(elapsedTime) // Add a new entry if the array is empty
        }

        // Save the updated study data to the JSON file
        saveStudyData()
    }

    // Save study data to a JSON file
    private func saveStudyData() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent("study_data.json")

        do {
            let data = try JSONEncoder().encode(weeklyStudyData)
            try data.write(to: fileURL)
            print("Study data saved successfully.")
        } catch {
            print("Failed to save study data: \(error)")
        }
    }

    // Format seconds into HH:MM:SS
    private func formatTime(_ totalSeconds: Int) -> String {
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
