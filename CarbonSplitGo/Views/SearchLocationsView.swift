import SwiftUI
import MapKit
import Combine

enum ActiveLocationTextField {
    case startingLocation
    case endLocation
}

struct SearchLocationsView: View {
    @StateObject private var userLocationViewModel = UserLocationViewModel()
    @StateObject private var suggestionsViewModel = SuggestionsViewModel()
    @State private var startingLocationPreview: String = ""
    @State private var endLocationPreview: String = ""
    @State private var startingLocationSaved: String = ""
    @State private var endLocationSaved: String = ""
    @FocusState private var activeLocationTextField: ActiveLocationTextField? 
        
        var body: some View {
            ZStack {
                Map(position: $userLocationViewModel.userPosition) {
                    UserAnnotation()
                }
                
                VStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 30)
                        .fill(AppColours.customGreen)
                        .overlay(
                            VStack() {
                                HStack(spacing: 0) {
                                    VStack(spacing: 0) {
                                        TextField("From..", text: $startingLocationPreview)
                                            .textFieldStyle(PlainTextFieldStyle())
                                            .padding(10)
                                            .background(AppColours.customLightGrey)
                                            .focused($activeLocationTextField, equals: .startingLocation)
                                            .onChange(of: startingLocationPreview) { oldValue, newValue in
                                                suggestionsViewModel.fetchSuggestionsPlacesAPI(for: newValue)
                                            }

                                        TextField("To..", text: $endLocationPreview)
                                            .textFieldStyle(PlainTextFieldStyle())
                                            .padding(10)
                                            .background(AppColours.customLightGrey)
                                            .focused($activeLocationTextField, equals: .endLocation)
                                            .onChange(of: endLocationPreview) { oldValue, newValue in
                                                suggestionsViewModel.fetchSuggestionsPlacesAPI(for: newValue)
                                            }
                                        }
                                            
                                    Button(action:navigateToNextView) {
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
                                                            startingLocationPreview = locationSuggestion.name
                                                        } else if activeLocationTextField == .endLocation {
                                                            endLocationPreview = locationSuggestion.name
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
                        .frame(height: 350)
                        .padding(.horizontal, 20)
                }
            }
        }
    
    private func navigateToNextView() {
        startingLocationSaved = startingLocationPreview
        endLocationSaved = endLocationPreview
        startingLocationPreview = ""
        endLocationPreview = ""
        print("Navigating with your location: \(startingLocationSaved), destination: \(endLocationSaved)")
    }
}

#Preview{
    SearchLocationsView()
}
