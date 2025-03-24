import SwiftUI

struct LoginView: View {
    @StateObject private var authenticationViewModel = AuthenticationViewModel()
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var isLoggedIn = false

    var body: some View {
        NavigationStack {
            ZStack {
                Image("RegisterWallpaper")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 30) {
                    Text("Login")
                        .font(.custom("Sen", size: 45))
                        .foregroundColor(AppColours.customDarkGrey)

                    VStack(spacing: 15) {
                        CustomTextField(placeholder: "Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        CustomTextField(placeholder: "Password", text: $password, isSecure: true)
                    }
                    .padding(.horizontal)

                    if let error = errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.custom("Sen", size: 20))
                    }

                    Button(action: loginUser) {
                        Text("Login")
                            .foregroundColor(AppColours.customWhite)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppColours.customMediumGreen)
                            .cornerRadius(30)
                            .font(.custom("Sen", size: 20))
                    }
                    .padding(.horizontal)

                    NavigationLink(destination: RegisterView().navigationBarBackButtonHidden(true)) {
                        Text("Don't have an account?")
                            .foregroundColor(AppColours.customDarkGrey)
                            .font(.custom("Sen", size: 18))
                    }
                }
                .padding(.horizontal, 50)
            }
            .overlay(
                GeometryReader { geometry in
                    CustomBackButton()
                        .position(x: 45, y: 20)
                }
            )
            .navigationDestination(isPresented: $isLoggedIn) {
                MainPageView().navigationBarBackButtonHidden(true)
            }
        }
    }
    
    private func loginUser() {
        authenticationViewModel.loginUser(email: email, password: password) { success in
            if success {
                do {
                    //making it so user becomes online after logging in
                    let changeStatusResult = try UserMaintenanceQueries.changeUserToOnline(email: self.email)
                    
                    if changeStatusResult {
                        DispatchQueue.main.async {
                            self.isLoggedIn = true
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.errorMessage = "failed."
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.errorMessage = "Failed to update user status: \(error.localizedDescription)"
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = self.authenticationViewModel.errorMessage
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
