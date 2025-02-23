import SwiftUI

struct StartPage: View {
    @State private var weeklyStudyData: [Int] = [] // State to hold weekly study data

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    // Top Layer: Graph
                    GraphView(weeklyStudyData: $weeklyStudyData) // Pass the binding
                        .frame(height: geometry.size.height * 0.5) // 50% of screen height
                        .background(Color.blue.opacity(0.1))
                        .padding(.bottom, 20)

                    // Middle Layer: Donation Text
                    Text("10 mins = $1 donation")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    Text("Every 10 mins that you study, $1 will be donated to a charity")
                        .font(.body)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)

                    // Bottom Layer: Start Button
                    NavigationLink(destination: TimerSetupView(weeklyStudyData: $weeklyStudyData)) { // Pass the binding
                        Text("Start")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}
