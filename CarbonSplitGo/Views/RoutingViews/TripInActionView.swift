import SwiftUI
import MapKit

struct TripInActionView: View {
    @EnvironmentObject var suggestionsViewModel: SuggestionsViewModel
    @ObservedObject var routingViewModel: RoutingViewModel
    @StateObject private var routeGroupViewModel = RouteGroupViewModel()

    @State private var selectedAnnotation: MKPointAnnotation?
    @State private var coordinatesForPassengerView: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)

    @State private var invitedPassengers: [(userId: Int, groupName: String, routeDay: String, userName: String)] = []
    
    @State private var isMapPopupFullscreen: Bool = false
    
    @State private var moveToTripEnd = false


    var body: some View {
        ZStack {
            AppColours.customWhite.ignoresSafeArea()
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
                    Text("Trip for \(invitedPassengers.isEmpty ? "N/A" : invitedPassengers[0].groupName)")
                        .foregroundColor(AppColours.customWhite)
                        .font(.custom("Sen", size: 32))
                        .padding(.top, -20)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                Text((invitedPassengers.isEmpty ? "N/A" : invitedPassengers[0].routeDay.prefix(10)))
                    .foregroundColor(AppColours.customDarkGrey)
                    .font(.custom("Sen", size: 20))
                    .padding(.bottom, 5)
                Text("Sharing The Trip With:")
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
                                    NavigationLink(destination: MessagesView(senderId: Session.shared.getUserID() ?? 0, receiverId: passenger.userId, friendName: passenger.userName)
                                        .navigationBarBackButtonHidden(true)) {
                                            Image(systemName: "message")
                                                .foregroundColor(AppColours.customDarkGreen)
                                                .font(.custom("Sen", size: 20))
                                        }
                                }
                                .padding()
                                .frame(maxWidth: 180)
                            }
                            Divider().frame(width: 300,height: 1).background(AppColours.customMediumGreen)
                            
                        }
                        
                    }
                }
                .frame(maxHeight: 150)
                .padding(.bottom, 15)
                
                VStack {
                    ZStack {
                        Grid(alignment: .leading, horizontalSpacing: 30, verticalSpacing: 10) {
                            GridRow {
                                RouteDetailRow(
                                    icon: "location",
                                    label: "Distance",
                                    value: "\(String(format: "%.2f", routingViewModel.selectedRouteDistance ?? 0)) km."
                                )
                                RouteDetailRow(
                                    icon: "clock",
                                    label: "Time",
                                    value: "~\(String(format: "%.0f", routingViewModel.selectedRouteTravelTime ?? 0)) min."
                                )
                            }
                            GridRow {
                                RouteDetailRow(
                                    icon: "car.fill",
                                    label: "Tolls",
                                    value: routingViewModel.selectedRouteHasTolls == true ? "Yes" : "No"
                                )
                                RouteDetailRow(
                                    icon: "leaf.fill",
                                    label: "CO₂",
                                    value: "\(String(format: "%.2f", routingViewModel.selectedRouteCo2Emissions ?? 0)) kg."
                                )
                            }
                        }
                    }
                }
                
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
                        isMapPopupFullscreen.toggle()
                    }) {
                        Text("Map Fullscreen")
                            .foregroundColor(AppColours.customWhite)
                            .frame(maxWidth: 300)
                            .padding()
                            .background(AppColours.customMediumGreen)
                            .cornerRadius(30)
                    }
                    
                    Button(action: {
                        Task {
                            //changed incase I will need this again later
                            moveToTripEnd = true
                        }
                    }) {
                        Text("End Trip")
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
                    .navigationDestination(isPresented: $moveToTripEnd) {
                        TripEndView(
                            routingViewModel: routingViewModel,
                            passengerCount: invitedPassengers.count,
                            routeCo2Emissions: routingViewModel.selectedRouteCo2Emissions ?? 0.0,
                            routeDistance: routingViewModel.selectedRouteDistance ?? 0.0
                        )
                        .navigationBarBackButtonHidden(true)
                    }
                }
            }
            
            .padding(.bottom, 20)
            .fullScreenCover(isPresented: $isMapPopupFullscreen) {
                MapPopupView(routingViewModel: routingViewModel)
                    .ignoresSafeArea()
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
}
//could probably reuse some other view, but made a new clean one
struct MapPopupView: View {
    @EnvironmentObject var suggestionsViewModel: SuggestionsViewModel
    @ObservedObject var routingViewModel: RoutingViewModel
    @State private var selectedAnnotation: MKPointAnnotation?
    @State private var coordinatesForPassengerView: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)


    var body: some View {
        VStack {
            CustomMapView(
                routes: routingViewModel.routes,
                annotations: $routingViewModel.annotations,
                selectedAnnotation: $selectedAnnotation,
                selectedRouteIndex: $routingViewModel.selectedRouteIndex,
                showOnlySelectedRoute: true
            )
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
        .overlay(
            GeometryReader { geometry in
                CustomBackButton()
                    .position(x: 40, y: 45)
            }
        )
    }
}
// Preview
struct TripInActionView_Previews: PreviewProvider {
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

        return TripInActionView(routingViewModel: routingViewModel)
            .environmentObject(suggestionsViewModel)
    }
}
