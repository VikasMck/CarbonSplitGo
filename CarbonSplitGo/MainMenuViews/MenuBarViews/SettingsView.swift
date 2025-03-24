import SwiftUI

struct SettingsView: View {
    @State private var notificationsEnabled = true
    @State private var darkModeEnabled = false
    @State private var showDeleteConfirmation = false
    @State private var highContrastEnabled = false
    @State private var screenReaderEnabled = false
    
    @State private var selectedLanguage = "English"
    @State private var fontSize: Double = 16
    
    let languages = ["English", "Lithuanian", "Russian", "Ukrainian", "Bulgarian"]
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottom) {
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: AppColours.customMediumGreen, location: 0.0),
                        .init(color: AppColours.customMediumGreen, location: 0.9),
                        .init(color: (darkModeEnabled == true ? AppColours.customBlack : AppColours.customWhite), location: 1.0)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 100)
                
                Text("Settings")
                    .foregroundColor(AppColours.customWhite)
                    .font(.custom("Sen", size: 32))
                    .padding(.bottom, 10)
            }
            .ignoresSafeArea(edges: .top)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Toggle("Notifications", isOn: $notificationsEnabled)
                        .tint(AppColours.customDarkGreen)
                        .font(.custom("Sen", size: fontSize))
                        .foregroundColor(darkModeEnabled == true ? AppColours.customWhite : AppColours.customBlack)
                    
                    Divider().frame(width: 300, height: 1).background(AppColours.customDarkGreen).frame(maxWidth: .infinity)
                    
                    Toggle("Dark Mode", isOn: $darkModeEnabled)
                        .tint(AppColours.customDarkGreen)
                        .font(.custom("Sen", size: fontSize))
                        .foregroundColor(darkModeEnabled == true ? AppColours.customWhite : AppColours.customBlack)
                    
                    Divider().frame(width: 300, height: 1).background(AppColours.customDarkGreen).frame(maxWidth: .infinity)
                    
                    Toggle("High Contrast Mode", isOn: $highContrastEnabled)
                        .tint(AppColours.customDarkGreen)
                        .font(.custom("Sen", size: fontSize))
                        .foregroundColor(darkModeEnabled == true ? AppColours.customWhite : AppColours.customBlack)
                    
                    Divider().frame(width: 300, height: 1).background(AppColours.customDarkGreen).frame(maxWidth: .infinity)
                    
                    Toggle("Screen Reader", isOn: $screenReaderEnabled)
                        .tint(AppColours.customDarkGreen)
                        .font(.custom("Sen", size: fontSize))
                        .foregroundColor(darkModeEnabled == true ? AppColours.customWhite : AppColours.customBlack)
                    
                    
                    Divider().frame(width: 300, height: 1).background(AppColours.customDarkGreen).frame(maxWidth: .infinity)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Font Size")
                            .font(.custom("Sen", size: fontSize))
                            .foregroundColor(darkModeEnabled == true ? AppColours.customWhite : AppColours.customBlack)
                        
                        Slider(value: $fontSize, in: 12...24, step: 0.5)
                            .tint(AppColours.customDarkGreen)
                        Text("Current Font Size: \(fontSize, specifier: "%.1f")")
                            .font(.custom("Sen", size: 13))
                            .foregroundColor(darkModeEnabled == true ? AppColours.customWhite : AppColours.customDarkGrey)
                        
                    }
                }
                .padding()
                
                Divider().frame(width: 300, height: 1).background(AppColours.customDarkGreen).frame(maxWidth: .infinity)
                
                HStack {
                    Text("Current Language:")
                        .font(.custom("Sen", size: fontSize))
                        .foregroundColor(darkModeEnabled == true ? AppColours.customWhite : AppColours.customBlack)
                    Menu {
                        ForEach(languages, id: \.self) { language in
                            Button(action: {
                                selectedLanguage = language
                            }) {
                                Text(language)
                                    .font(.custom("Sen", size: fontSize))
                            }
                        }
                    } label: {
                        Text(selectedLanguage)
                            .font(.custom("Sen", size: fontSize))
                            .foregroundColor(darkModeEnabled == true ? AppColours.customWhite : AppColours.customBlack)
                    }
                }.padding(8)
                
                
                Divider().frame(width: 300, height: 1).background(AppColours.customDarkGreen).frame(maxWidth: .infinity).padding(.bottom, 80)
                
                NavigationLink(destination: AuthenticateView()                    .navigationBarBackButtonHidden(true)) {
                        Text("Sign Out")
                            .foregroundColor(AppColours.customWhite)
                            .frame(width: 300)
                            .padding(.vertical, 15)
                            .background(AppColours.customDarkGreen)
                            .cornerRadius(30)
                    }

                Button(action: { showDeleteConfirmation = true }) {
                    Text("Delete Account")
                        .foregroundColor(AppColours.customWhite)
                        .frame(width: 300)
                        .padding(.vertical, 15)
                        .background(.red)
                        .cornerRadius(30)
                }
            }
        }
        .overlay(
            GeometryReader { geometry in
                CustomBackButton()
                    .position(x: 35, y: 0)
            }
        )
        .alert(isPresented: $showDeleteConfirmation) {
            Alert(
                title: Text("Delete Account"),
                message: Text("This action cannot be undone."),
                primaryButton: .destructive(Text("Delete")) {},
                secondaryButton: .cancel()
            )
        }
        .background(darkModeEnabled == true ? AppColours.customBlack : AppColours.customWhite)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
