import SwiftUI
import MapKit

struct TripEndView: View {
    @EnvironmentObject var suggestionsViewModel: SuggestionsViewModel
    @ObservedObject var routingViewModel: RoutingViewModel
    @StateObject private var routeGroupViewModel = RouteGroupViewModel()
    @StateObject private var userLocationViewModel = UserLocationViewModel()

    @State private var selectedAnnotation: MKPointAnnotation?
    @State private var coordinatesForPassengerView: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)

    @State private var invitedPassengers: [(userId: Int, groupName: String, routeDay: String, userName: String)] = []
    
    @State private var isMapPopupFullscreen: Bool = false
    @State private var ifFeedbackShown = false
    
    //need this because button and navigationlink have teamwork issues
    @State private var moveToMainPage = false

    @State private var selectedUserId: Int?
    @State private var selectedUserName: String?

    @State var passengerCount: Int
    @State var routeCo2Emissions: Double
    @State var routeDistance: Double

    var body: some View {
        VStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(stops: [
                            .init(color: AppColours.customMediumGreen, location: 0.0),
                            .init(color: AppColours.customMediumGreen, location: 0.9),
                            .init(color: AppColours.customWhite, location: 1.0)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                Text("Trip Summary\n  \(invitedPassengers.isEmpty ? "N/A" : invitedPassengers[0].groupName)")
                    .foregroundColor(AppColours.customWhite)
                    .font(.custom("Sen", size: 32))
                    .padding(.top, -20)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            Text((invitedPassengers.isEmpty ? "N/A" : invitedPassengers[0].routeDay.prefix(10)))
                .foregroundColor(AppColours.customDarkGrey)
                .font(.custom("Sen", size: 20))
                .padding(.bottom, 5)
            Text("Provide Feedback To:")
                .foregroundColor(AppColours.customDarkGrey)
                .font(.custom("Sen", size: 23))
            ScrollView {
                VStack(spacing: 0) {
                    if invitedPassengers.isEmpty{
                        Text("No passengers found")
                    }
                    else{
                        ForEach(Array(invitedPassengers.enumerated()), id: \.offset) { _, passenger in
                            Divider().frame(width: 300, height: 1).background(AppColours.customMediumGreen)
                            HStack {
                                Text(passenger.userName)
                                    .foregroundColor(AppColours.customDarkGrey)
                                    .font(.custom("Sen", size: 18))
                                Spacer()
                                Button(action: {
                                    selectedUserId = passenger.userId
                                    selectedUserName = passenger.userName
                                    ifFeedbackShown = true
                                }) {
                                    Image(systemName: "star.bubble.fill")
                                        .foregroundColor(AppColours.customDarkGreen)
                                        .font(.custom("Sen", size: 20))
                                }                            }
                            .padding()
                            .frame(maxWidth: 180)
                        }
                        Divider().frame(width: 300,height: 1).background(AppColours.customMediumGreen)

                    }

                }
            }
            .frame(maxHeight: 150)
            
            Text("You drove: \(passengerCount) \(passengerCount == 1 ? "person" : "people")")
            let co2Saved = (routeCo2Emissions * Double(passengerCount)) / Double(passengerCount + 1)
            
            Text("CO₂ saved: \(String(format: "%.2f", co2Saved)) kg")
            Text("Earned: \(String(format: "%.2f", co2Saved * 2.5)) Carbon Credits")
            
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .shadow(color: AppColours.customDarkGreen.opacity(0.9), radius: 10, x: 0, y: 0)
                
                CustomMapView(
                    routes: routingViewModel.routes,
                    annotations: $routingViewModel.annotations,
                    selectedAnnotation: $selectedAnnotation,
                    selectedRouteIndex: $routingViewModel.selectedRouteIndex,
                    showOnlySelectedRoute: true
                )
                .cornerRadius(30)
                .onAppear {
                    Task {
                        if suggestionsViewModel.locationForRouteList.first == "My Location" {
                            suggestionsViewModel.locationForRouteList[0] = Session.shared.getUserOriginalLocation() ?? ""
                        }
                        await routingViewModel.fetchCoordinates(from: suggestionsViewModel.locationForRouteList)
                        coordinatesForPassengerView = await routingViewModel.getCoordinatesFromAddress(for: suggestionsViewModel.locationForRouteList[0])
                        ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
                    }
                }
            }
            .padding()

            VStack(spacing: 16) {

                Button(action: {
                    Task {
                        await userLocationViewModel.updateUserRouteRewards(
                            userSavedCO2: co2Saved,
                            userDistanceShared: routeDistance,
                            userCarbonCredits: co2Saved * 2.5,
                            userId: Session.shared.getUserID() ?? 1
                        )
                        passengerCount = 0
                        routeCo2Emissions = 0.0
                        routeDistance = 0.0
                        moveToMainPage = true
                    }
                }) {
                    Text("Main Menu")
                        .foregroundColor(AppColours.customMediumGreen)
                        .frame(maxWidth: 300)
                        .padding()
                        .background(AppColours.customWhite)
                        .cornerRadius(30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color(AppColours.customLightGrey), lineWidth: 1)
                        )
                }
            }
            .navigationDestination(isPresented: $moveToMainPage) {
                MainPageView().navigationBarBackButtonHidden(true)
            }
        }
    
        .padding(.bottom, 20)
        .fullScreenCover(isPresented: $isMapPopupFullscreen) {
            MapPopupView(routingViewModel: routingViewModel)
            .ignoresSafeArea()
        }
        .sheet(isPresented: $ifFeedbackShown) {
            FeedbackView(feedbackViewModel: FeedbackViewModel(), userId: selectedUserId ?? 0, userName: selectedUserName ?? "")
            .presentationDetents([.height(500)])
            .presentationBackground(.clear)
        }
        .overlay(
            GeometryReader { geometry in
                CustomBackButton()
                    .position(x: 25, y: 20)
            }
        )
        .onAppear {
            Task {
                invitedPassengers = await routeGroupViewModel.fetchInvitedPassengerInfo(driverId: Session.shared.getUserID() ?? 0) ?? []
            }
        }
    }
}

// Preview
struct TripEndView_Previews: PreviewProvider {
    static var previews: some View {
        let routingViewModel = RoutingViewModel()
        routingViewModel.annotations = []
        routingViewModel.selectedRouteIndex = 0
        routingViewModel.selectedRouteDistance = 0
        routingViewModel.selectedRouteTravelTime = 0
        routingViewModel.selectedRouteHasTolls = false
        routingViewModel.selectedRouteCo2Emissions = 0
        
        Session.shared.setUserID(1)

        let suggestionsViewModel = SuggestionsViewModel()
        suggestionsViewModel.locationForRouteList = ["Dubin", "Cork"]

        return TripEndView(routingViewModel: routingViewModel, passengerCount: 2, routeCo2Emissions: 3.5, routeDistance: 131.12)
            .environmentObject(suggestionsViewModel)
    }
}
