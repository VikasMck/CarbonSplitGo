import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var phoneNumber = ""
    @State private var dateOfBirth = ""
    @State private var savedCO2 = 0.0
    @State private var distanceShared = 0.0
    @State private var carbonCredits = 0.0
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
                    Text("Create an Account")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(AppColours.customDarkGrey)
                        .padding(.top, 80)

                    VStack(spacing: 15) {
                        CustomTextField(placeholder: "Username", text: $username)
                        CustomTextField(placeholder: "Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        CustomTextField(placeholder: "Password", text: $password, isSecure: true)
                        CustomTextField(placeholder: "First Name [Optional]", text: $firstName)
                        CustomTextField(placeholder: "Last Name [Optional]", text: $lastName)
                        CustomTextField(placeholder: "Phone Number", text: $phoneNumber)
                            .keyboardType(.phonePad)
                        CustomTextField(placeholder: "Date of Birth (YYYY-MM-DD)", text: $dateOfBirth)
                            .keyboardType(.numbersAndPunctuation)
                    }
                    .padding(.horizontal)

                    if let error = errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.subheadline)
                            .padding(.vertical, 5)
                    }

                    Button(action: registerUser) {
                        Text("Register")
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
                        navigationPath.append("login")
                    } label: {
                        Text("Already have an account?")
                            .foregroundColor(AppColours.customDarkGrey)
                    }
                }
                .padding(.horizontal, 50)
            }
        }
    }

    private func registerUser() {
        let user = User(
            userName: username,
            userEmail: email,
            userPassword: password,
            userFirstName: firstName.isEmpty ? nil : firstName,
            userLastName: lastName.isEmpty ? nil : lastName,
            isOnline: true,
            isVerified: false,
            verificationToken: nil,
            userPhoneNumber: phoneNumber.isEmpty ? nil : phoneNumber,
            userProfilePictureURL: nil,
            userDateOfBirth: dateOfBirth.isEmpty ? nil : dateOfBirth,
            userDefaultRole: "passenger",
            userSavedCO2: savedCO2,
            userDistanceShared: distanceShared,
            userCarbonCredits: carbonCredits
        )

        viewModel.registerUser(user: user) { success in
            if success {
                navigationPath.removeLast(navigationPath.count) // Reset path
                navigationPath.append("login") // Navigate to MainPageView
            } else {
                errorMessage = viewModel.errorMessage
            }
        }
    }
}

