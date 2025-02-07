import SwiftUI

struct AuthenticateView: View {
    @State private var navigationPath = NavigationPath()

    var body: some View {
        GeometryReader { geometry in
            NavigationStack(path: $navigationPath) {
                ZStack {
                    Image("Wallpaper1")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)

                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.blue)
                            .padding()

                        Text("CarbonSplitGo")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        VStack(spacing: 15) {
                            Button {
                                navigationPath.append("register")
                            } label: {
                                Text("Register")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }

                            Button {
                                navigationPath.append("login")
                            } label: {
                                Text("Login")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal, 20)

                        Spacer()
                    }
                    .padding()
                    .background(Color.gray.opacity(0.7))
                    .cornerRadius(20)
                    .padding(25)
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
}

#Preview {
    AuthenticateView()
}
