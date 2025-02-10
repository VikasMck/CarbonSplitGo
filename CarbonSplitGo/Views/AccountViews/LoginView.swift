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

            ScrollView {
                VStack(spacing: 30) {
                    Text("Login")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(AppColours.customDarkGrey)
                        .padding(.top, 80)

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
                            .font(.subheadline)
                            .padding(.vertical, 5)
                    }

                    Button(action: loginUser) {
                        Text("Login")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppColours.customDarkGrey)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .padding(.horizontal)

                    Button {
                        navigationPath.append("register")
                    } label: {
                        Text("Don't have an account? Register")
                            .foregroundColor(AppColours.customDarkGrey)
                    }
                }
                .padding(.horizontal, 50)
            }
        }
    }

    private func loginUser() {
        authenticationViewModel.loginUser(email: email, password: password) { success in
            if success {
                navigationPath.removeLast(navigationPath.count)
                navigationPath.append("main")
            } else {
                errorMessage = authenticationViewModel.errorMessage
            }
        }
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()
    return LoginView(navigationPath: $path)
}
