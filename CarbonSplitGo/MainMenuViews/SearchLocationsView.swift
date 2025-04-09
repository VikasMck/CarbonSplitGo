import SwiftUI
import MapKit
import Combine

enum ActiveLocationTextField {
    case startingLocation
    case endLocation
}

enum UserChoiceOfDirection {
    case home, work
}

struct SearchLocationsView: View {
    @StateObject private var userLocationViewModel = UserLocationViewModel()
    @EnvironmentObject var suggestionsViewModel: SuggestionsViewModel
    @FocusState private var activeLocationTextField: ActiveLocationTextField?
    @State private var userChoiceOfDirection: UserChoiceOfDirection = .work
    @State var passengerDirectionChoice: String = "Driver"
        
    var body: some View {
        ZStack {
            Map(position: $userLocationViewModel.userPosition) {
                UserAnnotation()
            }
            
            VStack {
                ContributionsHeaderView()
                VStack(spacing: 0){
                    HStack {
                        UnevenRoundedRectangle(cornerRadii: .init(
                            topLeading: 30,
                            bottomLeading: 0,
                            bottomTrailing: 0,
                            topTrailing: 30
                        ))
                        .stroke(AppColours.customDarkGrey, lineWidth: 2)
                        .fill(AppColours.customDarkGrey)
                        .frame(height: 50)
                        .overlay(
                            HStack {
                                CustomTextWithIconView(icon: "person.2.fill", text: "Friends", destination: SocialView().navigationBarBackButtonHidden(true))
                                Spacer()
                                CustomTextWithIconView(icon: "person.fill", text: "Profile", destination: ProfileView().navigationBarBackButtonHidden(true))
                                Spacer()
                                CustomTextWithIconView(icon: "gearshape.fill", text: "Settings", destination: SettingsView().navigationBarBackButtonHidden(true))
                            }
                                .padding(20)
                        )
                    }
                    UnevenRoundedRectangle(cornerRadii: .init(
                        topLeading: 0,
                        bottomLeading: 30,
                        bottomTrailing: 30,
                        topTrailing: 0
                    ))
                    .stroke(AppColours.customDarkGrey, lineWidth: 2)
                    .fill(AppColours.customLightGreen)
                    .overlay(
                        VStack {
                            VStack {
                                if Session.shared.getUserRole() == "Passenger" {
                                    Text("You are a " + Session.shared.getUserRole()! + ". Choose destination")
                                        .padding(.bottom, 10).padding(.bottom, -10).padding(.top, -13)
                                        .font(.custom("Sen", size: 17))
                                        .foregroundColor(AppColours.customDarkGrey)
                                        .padding(.top, -5)
                                    HStack(spacing: 0) {
                                        Button(action: {
                                            userChoiceOfDirection = .work
                                            passengerDirectionChoice = "Work"
                                        }) {
                                            Text("Work")
                                                .padding(5)
                                                .frame(maxWidth: .infinity)
                                        }
                                        .background(userChoiceOfDirection == .work ? AppColours.customDarkGrey : AppColours.customLightGrey)
                                        .foregroundColor(userChoiceOfDirection == .work ? AppColours.customWhite : AppColours.customBlack)
                                        
                                        Button(action: {
                                            userChoiceOfDirection = .home
                                            passengerDirectionChoice = "Home"
                                        }) {
                                            Text("Home")
                                                .padding(5)
                                                .frame(maxWidth: .infinity)
                                        }
                                        .background(userChoiceOfDirection == .home ? AppColours.customDarkGrey : AppColours.customLightGrey)
                                        .foregroundColor(userChoiceOfDirection == .home ? AppColours.customWhite : AppColours.customBlack)
                                    }
                                    .cornerRadius(30)
                                    .padding(.horizontal, 20)
                                }
                                else {
                                    Text("You are a " + Session.shared.getUserRole()!)
                                        .padding(.bottom, 10).padding(.bottom, -10).padding(.top, -13)
                                        .font(.custom("Sen", size: 17))
                                        .foregroundColor(AppColours.customDarkGrey)
                                }

                                HStack(spacing: 0) {
                                    VStack {
                                        VStack(spacing: 0) {
                                            TextField("From..", text: $suggestionsViewModel.locationForRouteList[0], prompt: Text("From..").foregroundColor(AppColours.customMediumGreen))
                                                .textFieldStyle(PlainTextFieldStyle())
                                                .padding(10)
                                                .foregroundColor(AppColours.customBlack)
                                                .font(.custom("Sen", size: 17))
                                                .background(AppColours.customWhite)
                                                .focused($activeLocationTextField, equals: .startingLocation)
                                                .onChange(of: suggestionsViewModel.locationForRouteList[0]) { oldValue, newValue in
                                                    suggestionsViewModel.fetchSuggestionsPlacesAPI(for: newValue)
                                                }
                                            Divider()
                                            TextField("To..", text: $suggestionsViewModel.locationForRouteList[suggestionsViewModel.locationForRouteCount - 1], prompt: Text("To..").foregroundColor(AppColours.customMediumGreen))
                                                .font(.custom("Sen", size: 17))
                                                .textFieldStyle(PlainTextFieldStyle())
                                                .padding(10)
                                                .foregroundColor(AppColours.customBlack)
                                                .background(AppColours.customWhite)
                                                .focused($activeLocationTextField, equals: .endLocation)
                                                .onChange(of: suggestionsViewModel.locationForRouteList[suggestionsViewModel.locationForRouteCount - 1]) { oldValue, newValue in
                                                    suggestionsViewModel.fetchSuggestionsPlacesAPI(for: newValue)
                                                }
                                        }.cornerRadius(15)
                                    }
                                    NavigationLink(destination: RouteView(passengerDirectionChoice: passengerDirectionChoice).navigationBarBackButtonHidden(true)){
                                        Image(systemName: "arrow.right")
                                            .foregroundColor(AppColours.customDarkGrey)
                                            .padding(10)
                                            .padding(.top, 10)
                                            .font(.title)
                                    }
                                }
                                .padding(.horizontal)
                                
                                if !suggestionsViewModel.mapLocation.isEmpty {
                                    ScrollView {
                                        VStack(alignment: .leading, spacing: 5) {
                                            if((Session.shared.getUserOriginalLocation()) != nil) {
                                                Text("My Location")
                                                    .padding(.horizontal, 10)
                                                    .font(.custom("Sen", size: 15))
                                                    .foregroundColor(.blue)
                                                    .onTapGesture {
                                                        suggestionsViewModel.locationForRouteList[0] = "My Location"
                                                    }
                                                Divider()
                                            }
                                            ForEach(suggestionsViewModel.mapLocation, id: \.id) { locationSuggestion in
                                                Text(locationSuggestion.name)
                                                    .font(.custom("Sen", size: 15))
                                                    .foregroundColor(AppColours.customDarkGrey)
                                                    .padding(.vertical, 5)
                                                    .onTapGesture {
                                                        if activeLocationTextField == .startingLocation {
                                                            suggestionsViewModel.locationForRouteList[0] = locationSuggestion.name
                                                        } else if activeLocationTextField == .endLocation {
                                                            suggestionsViewModel.locationForRouteList[suggestionsViewModel.locationForRouteCount - 1] = locationSuggestion.name
                                                        }
                                                        suggestionsViewModel.mapLocation.removeAll()
                                                    }
                                                    .padding(.horizontal, 10)
                                                Divider().padding(.trailing, 55)
                                            }
                                        }
                                    }
                                    .padding(.leading, 20)
                                }
                                Spacer()
                            }
                            .padding(.top, 20)
                        }
                    )
                    .frame(height: 300)
                    
                }.padding(.horizontal, 10)
                
            }
            
            .navigationBarHidden(true)
            .overlay(
                GeometryReader { geometry in
                    CustomBackButton()
                        .position(x: 35, y: -10)
                }
            )
        }
    }
}
    
struct SearchLocationsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SearchLocationsView(passengerDirectionChoice: "Passenger")
                .environmentObject(SuggestionsViewModel())
                .onAppear {
                    Session.shared.setUserRole("Passenger")
                }
        }
    }
}
