import SwiftUI
import MapKit
import Combine

enum ActiveLocationTextField {
    case startingLocation
    case middleLocation
    case endLocation
}

struct SearchLocationsView: View {
    @StateObject private var userLocationViewModel = UserLocationViewModel()
    @EnvironmentObject var suggestionsViewModel: SuggestionsViewModel
    @FocusState private var activeLocationTextField: ActiveLocationTextField?
        
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
                        .stroke(AppColours.customDarkGrey, lineWidth: 5)
                        .fill(AppColours.customDarkGrey)
                        .frame(height: 50)
                        .overlay(
                            HStack {
                                CustomTextWithIconView(icon: "person.2.fill", text: "Friends", destination: SocialView())
                                Spacer()
                                CustomTextWithIconView(icon: "person.fill", text: "Profile", destination: ProfileView())
                                Spacer()
                                CustomTextWithIconView(icon: "gearshape.fill", text: "Settings", destination: SettingsView())
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
                    .stroke(AppColours.customDarkGrey, lineWidth: 5)
                    .fill(AppColours.customLightGreen)
                    .overlay(
                        VStack() {
                            Text("You are a " + Session.shared.getUserRole()!)
                            .padding(.bottom, 10).padding(.bottom, -10).padding(.top, -13)
                            .font(.custom("Sen", size: 17))
                            .foregroundColor(AppColours.customDarkGrey)
                            HStack(spacing: 0) {
                                VStack() {
                                    VStack(spacing: 0){
                                        TextField("From..", text: $suggestionsViewModel.startingLocationSaved, prompt: Text("From..").foregroundColor(AppColours.customMediumGreen))
                                            .textFieldStyle(PlainTextFieldStyle())
                                            .padding(10)
                                            .foregroundColor(.black)
                                            .font(.custom("Sen", size: 17))
                                            .background(.white)
                                            .focused($activeLocationTextField, equals: .startingLocation)
                                            .onChange(of: suggestionsViewModel.startingLocationSaved) { oldValue, newValue in
                                                suggestionsViewModel.fetchSuggestionsPlacesAPI(for: newValue)
                                            }
                                        Divider()
                                        TextField("To..", text: $suggestionsViewModel.endLocationSaved, prompt: Text("To..").foregroundColor(AppColours.customMediumGreen))
                                            .font(.custom("Sen", size: 17))
                                            .textFieldStyle(PlainTextFieldStyle())
                                            .padding(10)
                                            .foregroundColor(.black)
                                            .background(.white)
                                            .focused($activeLocationTextField, equals: .endLocation)
                                            .onChange(of: suggestionsViewModel.endLocationSaved) { oldValue, newValue in
                                                suggestionsViewModel.fetchSuggestionsPlacesAPI(for: newValue)
                                            }
                                    }.cornerRadius(15)
                                }
                                NavigationLink(destination: RouteView().navigationBarBackButtonHidden(true)){
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
                                                    suggestionsViewModel.startingLocationSaved = "My Location"
                                                }

                                            Divider()
                                        }
                                        ForEach(suggestionsViewModel.mapLocation, id: \.id){
                                            locationSuggestion in Text(locationSuggestion.name)
                                                .font(.custom("Sen", size: 15))
                                                .foregroundColor(AppColours.customDarkGrey)
                                                .padding(.vertical, 5)
                                                .onTapGesture {
                                                    if activeLocationTextField == .startingLocation {
                                                        suggestionsViewModel.startingLocationSaved = locationSuggestion.name
                                                    } else if activeLocationTextField == .endLocation {
                                                        suggestionsViewModel.endLocationSaved = locationSuggestion.name
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
    

#Preview{
    SearchLocationsView()
        .environmentObject(SuggestionsViewModel())
}
