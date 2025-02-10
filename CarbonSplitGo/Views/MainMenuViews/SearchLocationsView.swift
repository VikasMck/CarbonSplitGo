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
                    Spacer()
                    UnevenRoundedRectangle(cornerRadii: .init(
                        topLeading: 0,
                        bottomLeading: 30,
                        bottomTrailing: 30,
                        topTrailing: 0
                    ))
                    .fill(AppColours.customMediumGreen)
                        .overlay(
                            VStack() {
                                HStack(spacing: 0) {
                                    VStack(spacing: 0) {
                                        TextField("From..", text: $suggestionsViewModel.startingLocationSaved)
                                            .textFieldStyle(PlainTextFieldStyle())
                                            .padding(10)
                                            .background(AppColours.customLightGrey)
                                            .focused($activeLocationTextField, equals: .startingLocation)
                                            .onChange(of: suggestionsViewModel.startingLocationSaved) { oldValue, newValue in
                                                suggestionsViewModel.fetchSuggestionsPlacesAPI(for: newValue)
                                            }
                                        
                                        TextField("To..", text: $suggestionsViewModel.endLocationSaved)
                                            .textFieldStyle(PlainTextFieldStyle())
                                            .padding(10)
                                            .background(AppColours.customLightGrey)
                                            .focused($activeLocationTextField, equals: .endLocation)
                                            .onChange(of: suggestionsViewModel.endLocationSaved) { oldValue, newValue in
                                                suggestionsViewModel.fetchSuggestionsPlacesAPI(for: newValue)
                                            }
                                    }
                                    NavigationLink(destination: RouteView().navigationBarBackButtonHidden(true)){
                                        Image(systemName: "arrow.right")
                                            .foregroundColor(.white)
                                            .padding(10)
                                            .background(AppColours.customDarkGrey)
                                            .clipShape(Rectangle())
                                    
                                    }
                                }
                                
                                .padding(.horizontal)
                                
                                if !suggestionsViewModel.mapLocation.isEmpty {
                                    ScrollView {
                                        VStack(alignment: .leading, spacing: 5) {
                                            ForEach(suggestionsViewModel.mapLocation, id: \.id){
                                                locationSuggestion in Text(locationSuggestion.name)
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
                                                Divider()
                                            }
                                        }
                                    }
                                    .frame(maxHeight: 150)
                                    .padding(.horizontal)
                                }
                                Spacer()
                            }
                                .padding(.top, 20)
                        )
                        .frame(height: 330)
                        .padding(.horizontal, 20)
                    
                }
                
            }.navigationBarHidden(true)
        }
    }
    

#Preview{
    SearchLocationsView()
        .environmentObject(SuggestionsViewModel())
}
