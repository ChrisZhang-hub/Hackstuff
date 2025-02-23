//
//  SignUpView.swift
//  Study
//
//  Created by Chen Ryan on 21/2/2025.
//
import SwiftUI

struct SignUpView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Sign Up")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)

                // Name Field
                TextField("Full Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    

                // Email Field
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    

                // Password Field
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                // Confirm Password Field
                SecureField("Confirm Password", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                // Sign-Up Button
                Button(action: {
                    signUp()
                }) {
                    Text("Sign Up")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }

                // Navigation back to Login
                NavigationLink(destination: ContentView()) {
                    Text("Already have an account? Login")
                        .foregroundColor(.blue)
                        .padding(.top, 10)
                }
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Sign-Up Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    // Sign-Up Validation Logic
    private func signUp() {
        if name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            alertMessage = "All fields are required."
            showAlert = true
        } else if !email.contains("@") {
            alertMessage = "Enter a valid email address."
            showAlert = true
        } else if password.count < 6 {
            alertMessage = "Password must be at least 6 characters."
            showAlert = true
        } else if password != confirmPassword {
            alertMessage = "Passwords do not match."
            showAlert = true
        } else {
            // Simulating successful sign-up
            alertMessage = "Account created successfully!"
            showAlert = true
        }
    }
}

// Preview
struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

