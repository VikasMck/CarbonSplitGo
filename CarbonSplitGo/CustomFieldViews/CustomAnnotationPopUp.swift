import SwiftUI
import MapKit

struct CustomAnnotationPopUp: View {
    let annotation: MKPointAnnotation
    @StateObject private var routeGroupViewModel = RouteGroupViewModel()
    @EnvironmentObject var suggestionViewModel: SuggestionsViewModel
    //hide when something is pressed
    @Environment(\.presentationMode) var isButtonPressed
    
    var body: some View {
        VStack() {
    
            if let errorMessage = routeGroupViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.custom("Sen", size: 20))
            }
            else {
                List(routeGroupViewModel.annotationPopupInfo, id: \.groupName) { popupInfo in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(popupInfo.groupName)
                            .font(.custom("Sen", size: 20))
                            .foregroundColor(AppColours.customDarkGrey)
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text("User: \(popupInfo.userName)")
                            .font(.custom("Sen", size: 17))
                            .foregroundColor(AppColours.customDarkGrey)
                        Text("Day: \(popupInfo.routeDay.prefix(10))")
                            .font(.custom("Sen", size: 17))
                            .foregroundColor(AppColours.customDarkGrey)
                        Text("Time: \(popupInfo.routeDay.suffix(5))")
                            .font(.custom("Sen", size: 17))
                            .foregroundColor(AppColours.customDarkGrey)
                        Text("Number: \(popupInfo.userPhoneNumber)")
                            .font(.custom("Sen", size: 17))
                            .foregroundColor(AppColours.customDarkGrey)
                        Text("Status: \(popupInfo.isVerified ? "Verified" : "Unverified")")
                            .font(.custom("Sen", size: 17))
                            .foregroundColor(AppColours.customDarkGrey)

                    }.listRowBackground(Color.white)

                }
                .frame(height: 200)
                .listStyle(PlainListStyle())

            }
            
            HStack() {
                Button(action: {
                    Task {
                        await routeGroupViewModel.updatePassengerIncludedStatus(
                            passengerIncluded: true,
                            longitude: annotation.coordinate.longitude,
                            latitude: annotation.coordinate.latitude
                        )
                        
                        suggestionViewModel.locationForRouteList.insert("\(annotation.coordinate.latitude),\(annotation.coordinate.longitude)", at: max(suggestionViewModel.locationForRouteList.count - 1, 0))
                        
                        isButtonPressed.wrappedValue.dismiss()
                    }
                }) {
                    Text("Invite")
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(AppColours.customMediumGreen)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
                
                Button(action: {
                    Task {
                        await routeGroupViewModel.updatePassengerIncludedStatus(
                            passengerIncluded: false,
                            longitude: annotation.coordinate.longitude,
                            latitude: annotation.coordinate.latitude
                        )
                        
                        if let deleteAt = suggestionViewModel.locationForRouteList.firstIndex(where: { $0 == "\(annotation.coordinate.latitude),\(annotation.coordinate.longitude)" }) {
                            suggestionViewModel.locationForRouteList.remove(at: deleteAt)
                        }

                        isButtonPressed.wrappedValue.dismiss()
                    }
                }) {
                    Text("Ignore")
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(AppColours.customDarkGrey)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
            }
        }
        .padding()
        .frame(width: 300, alignment: .center)
        .background(.white)
        .cornerRadius(30)
        .shadow(color: AppColours.customDarkGreen.opacity(0.5), radius: 5, x: 0, y: 0)
        .onAppear {
            Task {
                await routeGroupViewModel.fetchAnnotationPopupInfo(
                    longitude: annotation.coordinate.longitude,
                    latitude: annotation.coordinate.latitude
                )
            }
        }
        .overlay(
            GeometryReader { geometry in
                CustomBackButton()
                    .position(x: 30, y: 30)
            }
        )
    }
}

#Preview {
    CustomAnnotationPopUp(
        annotation: {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: 53.3527667, longitude: -6.2799033)
            return annotation
        }()
    )
}
