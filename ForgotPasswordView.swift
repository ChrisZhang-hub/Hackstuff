//
//  ForgotPasswordView.swift
//  Study
//
//  Created by Chen Ryan on 21/2/2025.
//
import SwiftUI

struct ForgotPasswordView: View {
    @State private var email: String = ""
    @State private var showAlert = false

    var body: some View {
        VStack {
            Text("Reset Your Password")
                .font(.largeTitle)
                .padding()
            
            Text("Enter your email to receive a password reset link.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            TextField("Enter your email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                
                .autocorrectionDisabled(true)
                
            Button(action: sendResetEmail) {
                Text("Send Reset Link")
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Success"), message: Text("Password reset link sent! Check your email."), dismissButton: .default(Text("OK")))
            }
        }
        .padding()
    }

    // Simulated password reset function
    private func sendResetEmail() {
        if email.isEmpty {
            showAlert = true
        } else {
            // Simulate sending reset link
            showAlert = true
        }
    }
}

// Preview
struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}

