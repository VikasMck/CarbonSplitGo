import SwiftUI

struct RegisterView: View {
    @StateObject private var authenticationViewModel = AuthenticationViewModel()
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
    @State private var isRegistered = false

    var body: some View {
        NavigationStack {
            ZStack {
                Image("RegisterWallpaper")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)

                ScrollView {
                    VStack(spacing: 30) {
                        Text("Join Us!")
                            .fontWeight(.bold)
                            .foregroundColor(AppColours.customDarkGrey)
                            .padding(.top, 80)
                            .font(.custom("Sen", size: 45))

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
                                .font(.custom("Sen", size: 20))
                        }

                        Button(action: registerUser) {
                            Text("Register")
                                .foregroundColor(AppColours.customWhite)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(AppColours.customMediumGreen)
                                .cornerRadius(30)
                                .font(.custom("Sen", size: 20))
                        }
                        .padding(.horizontal)
                        
                        NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true)) {
                            Text("Already have an account?")
                                .foregroundColor(AppColours.customDarkGrey)
                                .font(.custom("Sen", size: 18))
                        }
                    }
                    .padding(.horizontal, 50)
                    .overlay(
                        GeometryReader { geometry in
                            CustomBackButton()
                                .position(x: 45, y: 20)
                        }
                    )
                }
            }
            .navigationDestination(isPresented: $isRegistered) {
                LoginView().navigationBarBackButtonHidden(true)
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

        authenticationViewModel.registerUser(user: user) { success in
            if success {
                DispatchQueue.main.async {
                    self.isRegistered = true
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = authenticationViewModel.errorMessage
                }
            }
        }
    }
}

#Preview {
    RegisterView()
}
