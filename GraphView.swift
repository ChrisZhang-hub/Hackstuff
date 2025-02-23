
import SwiftUI
// Graph View with Bar Chart
struct GraphView: View {
    @Binding var weeklyStudyData: [Int] // Binding to weekly study data

    var body: some View {
        VStack {
            Text("Daily Study Time")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 10)

            HStack(alignment: .bottom, spacing: 10) {
                ForEach(weeklyStudyData.indices, id: \.self) { index in
                    VStack {
                        // Display the time in "hr min" format on top of the column
                        Text(formatTime(weeklyStudyData[index])) // Updated to use "hr min" format
                            .font(.caption)
                            .foregroundColor(.black)
                            .padding(.bottom, 5) // Add some spacing between the text and the bar

                        Spacer()
                        Rectangle()
                            .fill(Color.blue)
                            .frame(width: 30, height: CGFloat(weeklyStudyData[index]) * 1) // Scale height for better visibility

                        // Display the day label at the bottom
                        Text(index == weeklyStudyData.count - 1 ? "Today" : "D\(index + 1)")
                            .font(.caption)
                            .foregroundColor(.black)
                            .padding(.top, 5) // Add some spacing between the bar and the label
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding(.horizontal, 20)
        .onAppear {
            // Load data when the view appears
            loadStudyData()
        }
    }

    // Load study data from a JSON file
    private func loadStudyData() {
        if let url = Bundle.main.url(forResource: "study_data", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decodedData = try JSONDecoder().decode([Int].self, from: data) // Decode as [Int] (minutes)
                weeklyStudyData = decodedData
            } catch {
                print("Failed to load or decode study data: \(error)")
            }
        } else {
            print("Could not find study_data.json in the bundle.")
        }
    }

    // Helper function to format time as "hr min"
    private func formatTime(_ minutes: Int) -> String {
        let formattedHours = minutes / 60
        let formattedMinutes = minutes % 60
        
        if formattedHours > 0 && formattedMinutes > 0 {
            return "\(formattedHours) hr \(formattedMinutes) mins"
        } else if formattedHours > 0 {
            return "\(formattedHours) hr"
        } else {
            return "\(formattedMinutes) mins"
        }
    }
}
