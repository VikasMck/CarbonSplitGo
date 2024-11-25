import SwiftUI

enum UserChoiceDriverPassenger{
        case passenger, driver
}


struct ControlPanelView: View {
    @State private var userChoiceDriverPassenger: UserChoiceDriverPassenger = .driver
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 0) {
                HStack {
                    UnevenRoundedRectangle(cornerRadii: .init(
                        topLeading: 30,
                        bottomLeading: 0,
                        bottomTrailing: 0,
                        topTrailing: 30
                    ))
                    .fill(Color(.darkGray))
                    .frame(height: 50)
                    .overlay(
                        HStack {
                            SettingsButtonView(icon: "gearshape.fill", text: "Settings")
                            Spacer()
                            SettingsButtonView(icon: "person.fill", text: "Profile")
                            Spacer()
                            SettingsButtonView(icon: "person.2.fill", text: "Friends")
                        }
                            .padding(20)
                    )
                }
                
                VStack {
                    UnevenRoundedRectangle(cornerRadii: .init(
                        topLeading: 0,
                        bottomLeading: 30,
                        bottomTrailing: 30,
                        topTrailing: 0
                    ))
                    .fill(AppColours.customGreen)
                    .frame(height: 300)
                    .overlay(
                        VStack(spacing: 15) {
                            NavigationLink(destination: SearchLocationsView()) {
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(AppColours.customDarkGrey)
                                    Text("I'm going to...")
                                        .foregroundColor(AppColours.customDarkGrey)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(AppColours.customDarkGrey)
                                    
                                }
                                .padding()
                                .background(AppColours.customLightGrey)
                                .cornerRadius(30)
                            }
                            .padding(.horizontal, 20)
                            
                            VStack(spacing: 0) {
                                UnevenRoundedRectangle(cornerRadii: .init(
                                    topLeading: 30,
                                    bottomLeading: 0,
                                    bottomTrailing: 0,
                                    topTrailing: 30
                                ))
                                .fill(AppColours.customDarkGrey)
                                .frame(height: 25)
                                .overlay {
                                    Text("Saved Locations")
                                        .foregroundColor(AppColours.customLightGrey)
                                }
                                
                                UnevenRoundedRectangle(cornerRadii: .init(
                                    topLeading: 0,
                                    bottomLeading: 30,
                                    bottomTrailing: 30,
                                    topTrailing: 0
                                ))
                                .fill(AppColours.customLightGrey)
                                .frame(height: 70)
                                .overlay(
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 50) {
                                            SavedLocationEntryView(icon: "location.fill", text: "Saved1")
                                            SavedLocationEntryView(icon: "location.fill", text: "Saved2")
                                            SavedLocationEntryView(icon: "location.fill", text: "Saved3")
                                            SavedLocationEntryView(icon: "location.fill", text: "Saved4")
                                            SavedLocationEntryView(icon: "location.fill", text: "Saved5")
                                        }
                                        .padding(.horizontal, 10)
                                    }
                                )
                                .clipShape(
                                    UnevenRoundedRectangle(cornerRadii: .init(
                                        topLeading: 0,
                                        bottomLeading: 30,
                                        bottomTrailing: 30,
                                        topTrailing: 0
                                    ))
                                )
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            
                            HStack(spacing: 0) {
                                Button(action: { userChoiceDriverPassenger = .driver }) {
                                    Text("I'm a Driver")
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                }
                                .background(userChoiceDriverPassenger == .driver ? AppColours.customDarkGrey : AppColours.customLightGrey)
                                .foregroundColor(userChoiceDriverPassenger == .driver ? .white : .black)
                                
                                Button(action: { userChoiceDriverPassenger = .passenger }) {
                                    Text("I'm a Passenger")
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                }
                                .background(userChoiceDriverPassenger == .passenger ? AppColours.customDarkGrey : AppColours.customLightGrey)
                                .foregroundColor(userChoiceDriverPassenger == .passenger ? .white : .black)
                            }
                            .cornerRadius(30)
                            .padding(.horizontal, 20)
                        }
                    )
                }
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 20)
        }
    }
}


struct SettingsButtonView: View {
    let icon: String
    let text: String
    
    var body: some View {
        Button(action: {}) {
            HStack {
                Image(systemName: icon)
                Text(text)
            }
            .foregroundColor(AppColours.customLightGrey)
        }
    }
}

struct SavedLocationEntryView: View {
    let icon: String
    let text: String
    
    var body: some View {
        VStack {
            Text(text)
                .font(.caption2)
                .foregroundColor(.black)
            Circle()
                .fill(AppColours.customDarkGrey)
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: icon)
                        .foregroundColor(AppColours.customLightGrey)
                )
        }
    }
}

#Preview {
    ControlPanelView()
}
