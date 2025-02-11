import SwiftUI

struct LoginView: View {
    @StateObject private var authenticationViewModel = AuthenticationViewModel()
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        ZStack {
            Image("RegisterWallpaper")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                Text("Login")
                    .font(.custom("Sen", size: 45))
                    .fontWeight(.bold)
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
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppColours.customDarkGreen)
                        .cornerRadius(30)
                        .font(.custom("Sen", size: 20))
                        .bold()
                }
                .padding(.horizontal)
                
                Button {
                    navigationPath.append("register")
                } label: {
                    Text("Don't have an account?")
                        .foregroundColor(AppColours.customDarkGrey)
                        .font(.custom("Sen", size: 18))
                    
                }
            }
            .padding(.horizontal, 50)
            
        }
    }
    
    private func loginUser() {
        authenticationViewModel.loginUser(email: email, password: password) { success in
            if success {
                do {
                    //making it so user becomes online after logging in
                    let changeStatusResult = try UserMaintenanceQueries.changeUserToOnline(email: self.email)
                    
                    //these try catches are getting on my nerves
                    if changeStatusResult {
                        DispatchQueue.main.async {
                            self.navigationPath.removeLast(self.navigationPath.count)
                            self.navigationPath.append("main")
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
    @Previewable @State var path = NavigationPath()
    return LoginView(navigationPath: $path)
}
