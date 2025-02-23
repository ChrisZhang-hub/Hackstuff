import SwiftUI

struct TwoFactorAuthView: View {
    @State private var showingChooseTimer = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Login Successful")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                    .padding(.bottom, 20)

                Text("You have successfully logged in!")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.green)
                    .padding()

                Button(action: {
                    showingChooseTimer = true
                    // Action when user presses "Continue"
                    // You can navigate to the home screen or close this view
                }) {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                // Navigation to ChooseTimer view when showingChooseTimer is true
                NavigationLink(destination: StartPage(), isActive: $showingChooseTimer) {
                    EmptyView() // EmptyView here ensures we can trigger the navigation programmatically
                }
                .buttonStyle(PlainButtonStyle()) // To avoid any button-like behavior in the link
                .padding(.horizontal)
            }
            .padding()
        }
    }
}


// Preview
struct TwoFactorAuthView_Previews: PreviewProvider {
    static var previews: some View {
        TwoFactorAuthView()
    }
}
