import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottom) {
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: AppColours.customMediumGreen, location: 0.0),
                        .init(color: AppColours.customMediumGreen, location: 0.9),
                        .init(color: AppColours.customWhite, location: 1.0)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 100)
                
                Text("Profile")
                    .foregroundColor(AppColours.customWhite)
                    .font(.custom("Sen", size: 32))
                    .padding(.bottom, 10)
            }
            .ignoresSafeArea(edges: .top)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Button(action: {}) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .foregroundColor(AppColours.customBlack)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    
                    Button(action: {}) {
                        Text("Change Username")
                            .foregroundColor(AppColours.customWhite)
                            .frame(width: 300)
                            .padding(.vertical, 15)
                            .background(AppColours.customDarkGreen)
                            .cornerRadius(30)
                            .font(.custom("Sen", size: 18))
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    Divider().frame(width: 300, height: 1).background(AppColours.customDarkGreen).frame(maxWidth: .infinity)

                    Button(action: {}) {
                        Text("Change Email")
                            .foregroundColor(AppColours.customWhite)
                            .frame(width: 300)
                            .padding(.vertical, 15)
                            .background(AppColours.customDarkGreen)
                            .cornerRadius(30)
                            .font(.custom("Sen", size: 18))
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    Divider().frame(width: 300, height: 1).background(AppColours.customDarkGreen).frame(maxWidth: .infinity)

                    Button(action: {}) {
                        Text("Change Phone Number")
                            .foregroundColor(AppColours.customWhite)
                            .frame(width: 300)
                            .padding(.vertical, 15)
                            .background(AppColours.customDarkGreen)
                            .cornerRadius(30)
                            .font(.custom("Sen", size: 18))

                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    Divider().frame(width: 300, height: 1).background(AppColours.customDarkGreen).frame(maxWidth: .infinity)

                    Button(action: {}) {
                        Text("Change Password")
                            .foregroundColor(AppColours.customWhite)
                            .frame(width: 300)
                            .padding(.vertical, 15)
                            .background(AppColours.customDarkGreen)
                            .cornerRadius(30)
                            .font(.custom("Sen", size: 18))

                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    Divider().frame(width: 300, height: 1).background(AppColours.customDarkGreen).frame(maxWidth: .infinity).padding(.bottom, 40)

                    Button(action: {}) {
                        Text("Verify Email")
                            .foregroundColor(AppColours.customWhite)
                            .frame(width: 300)
                            .padding(.vertical, 15)
                            .background(AppColours.customMediumGreen)
                            .cornerRadius(30)
                            .font(.custom("Sen", size: 18))
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding()
            }
        }
        .overlay(
            GeometryReader { _ in
                CustomBackButton()
                    .position(x: 35, y: 0)
            }
        )
        .background(AppColours.customWhite)
    }
}

#Preview {
    ProfileView()
}
