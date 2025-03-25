import SwiftUI

struct AuthenticateView: View {
    var body: some View {
        NavigationStack {
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
                        NavigationLink(destination: RegisterView()
                            .navigationBarBackButtonHidden(true)) {
                            Text("Register")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .font(.custom("Sen", size: 20))
                                .background(AppColours.customDarkGreen)
                                .foregroundColor(AppColours.customWhite)
                                .cornerRadius(30)
                        }

                        NavigationLink(destination: LoginView()                    .navigationBarBackButtonHidden(true)) {
                            Text("Login")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .font(.custom("Sen", size: 20))
                                .background(AppColours.customMediumGreen)
                                .foregroundColor(AppColours.customWhite)
                                .cornerRadius(30)
                        }
                    }
                    .padding(.horizontal, 40)
                    
                    Spacer().frame(height: 250)
                }
                .padding(.top, 20)
            }
        }
    }
}

#Preview {
    AuthenticateView()
}
