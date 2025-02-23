import SwiftUI
import WebKit

struct ContentView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isTwoFactorAuthRequired = false
    @State private var showAlert = false
    @State private var isLoading = false
    @State private var passwordValid: String? = nil
    @State private var isFocused: Bool = true
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Text("Sign In")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                
                // Email Field
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                
                // Password Field
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                //Password validation
                if let error = passwordValid {
                    Text(error  )
                        .font(.system(size:11,weight: .light, design: .serif))
                        .foregroundColor(.red)
                        .padding()
                }
                // Login Button
                Button(action: {
                    authenticateUser()
                }) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Login")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                    }
                }
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
                
                // Forgot Password & Sign Up Buttons
                HStack {
                    NavigationLink(destination: ForgotPasswordView()) {
                        Text("Forgot Password?")
                            .foregroundColor(.blue)
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: SignUpView()) {
                        Text("Sign Up")
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal, 30)
                
                // Navigation to 2FA Screen (Fix)
                .navigationDestination(isPresented: $isTwoFactorAuthRequired) {
                    TwoFactorAuthView()
                }
                .opacity(0) // Hide link visually
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Invalid Email"), message: Text("Please enter a valid email address."), dismissButton: .default(Text("OK")))
            }
            .onAppear {
                startCheckingFocus()
            }
        }
    }
    private func validPass(pass: String){
        var upper:Int = 0
        var num:Int = 0
        var charSet = CharacterSet.init(charactersIn: "!@#$%^&*()_+-=")

        for char in pass{
            if(char.isUppercase){
                upper+=1
            }
            if(char.isNumber){
                num+=1
            }
        }
        if (pass.rangeOfCharacter(from: charSet) != nil){
            if(upper>0 && num>0){
                passwordValid = nil
            }
        }
        else {
            passwordValid = "Password must contain at least one uppercase letter, one number, and one special character."
        }
    }
    
    //  Simulated Authentication
    private func authenticateUser() {
        validPass(pass: password)
        if passwordValid != nil {
                   return
               }
        
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if isValidEmail(email) {
                isTwoFactorAuthRequired = true //  Triggers 2FA Navigation
            } else {
                showAlert = true // Show error alert
            }
            isLoading = false
        }
    }
    
    //  Email Validation Function
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = #"^\S+@\S+\.\S+$"#
        return email.range(of: emailRegex, options: .regularExpression) != nil
    }
    
    // Function to check focus from HTML
    private func startCheckingFocus() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            checkFocusStatus()
        }
    }
    
    private func checkFocusStatus() {
        let url = URL(string: "http://localhost:8080/focus-status")!
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let status = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    self.isFocused = (status.trimmingCharacters(in: .whitespacesAndNewlines) == "Focused")
                }
            }
        }.resume()
    }
}

// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

