import SwiftUI

struct AuthenticateView: View {
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                AppColours.customLightGreen
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 20) {
                    Image("FakeLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: 400)

                    Text("CarbonSplitGo")
                        .font(.custom("Sen", size: 45))
                        .multilineTextAlignment(.center)
                        .padding(.top, -100)
                    Spacer()


                    VStack(spacing: 30) {
                        Button {
                            navigationPath.append("register")
                        } label: {
                            Text("Register")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .font(.custom("Sen", size: 20))
                                .background(AppColours.customDarkGreen)
                                .foregroundColor(.white)
                                .cornerRadius(30)
                        }

                        Button {
                            navigationPath.append("login")
                        } label: {
                            Text("Login")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .font(.custom("Sen", size: 20))
                                .background(AppColours.customMediumGreen)
                                .foregroundColor(.white)
                                .cornerRadius(30)
                        }
                    }
                    .padding(.horizontal, 40)
                    
                    Spacer().frame(height: 250)
                }
                .padding(.top, 20)
            }
            .navigationDestination(for: String.self) { value in
                if value == "register" {
                    RegisterView(navigationPath: $navigationPath)
                        .navigationBarBackButtonHidden(true)
                } else if value == "login" {
                    LoginView(navigationPath: $navigationPath)
                        .navigationBarBackButtonHidden(true)
                } else if value == "main" {
                    MainPageView()
                        .navigationBarBackButtonHidden(true)
                }
            }
        }
    }
}

#Preview {
    AuthenticateView()
}
