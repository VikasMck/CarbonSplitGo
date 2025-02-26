import SwiftUI
import MapKit

struct RouteView: View {
    @EnvironmentObject var suggestionsViewModel: SuggestionsViewModel
    //at first had all the logic here, but finally fixed so I can follow MVVM again
    @StateObject private var routingViewModel = RoutingViewModel()
    @State private var coordinatesForPassengerView: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    @State private var selectedAnnotation: MKPointAnnotation?

    var body: some View {
        ZStack {
            CustomMapView(
                routes: routingViewModel.routes,
                annotations: $routingViewModel.annotations,
                selectedAnnotation: $selectedAnnotation,
                selectedRouteIndex: $routingViewModel.selectedRouteIndex
            )
            
            VStack {
                CustomRouteSelectView(selectedRouteIndex: $routingViewModel.selectedRouteIndex, selectedRouteDistance: routingViewModel.selectedRouteDistance, selectedRouteTravelTime: routingViewModel.selectedRouteTravelTime, selectedRouteHasTolls: routingViewModel.selectedRouteHasTolls, selectedRouteCo2Emissions: routingViewModel.selectedRouteCo2Emissions,
                    onSelectMainRoute: { routingViewModel.selectMainRoute() },
                    onSelectAlternateRoute: { routingViewModel.selectAlternateRoute() }
                )
                .padding(.top, 30)

                Spacer()
            }
            .padding()

            if Session.shared.getUserRole() == "Passenger" {
                PassengerRouteSelectView(coordinates: coordinatesForPassengerView)
            }
            else if Session.shared.getUserRole() == "Driver" {
                DriverRouteSelectView(annotations: $routingViewModel.annotations) { fetchedUserCoordinates in
                    routingViewModel.addAnnotation(at: fetchedUserCoordinates)
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            if suggestionsViewModel.locationForRouteList.first == "My Location" {
                suggestionsViewModel.locationForRouteList[0] = Session.shared.getUserOriginalLocation() ?? ""
            }
            Task {
                await routingViewModel.fetchCoordinates(from: suggestionsViewModel.locationForRouteList)
                coordinatesForPassengerView = await routingViewModel.getCoordinatesFromAddress(for: suggestionsViewModel.locationForRouteList[0])
                    ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
                
                //suggestionsViewModel.locationForRouteList[0] = ""
                //suggestionsViewModel.locationForRouteList[suggestionsViewModel.locationForRouteCount - 1] = ""
            }
        }
        //this is so cool, sadly I have to repeat code, but it works the best this way
        .onChange(of: suggestionsViewModel.locationForRouteList) {
            Task {
                await routingViewModel.fetchCoordinates(from:
                    suggestionsViewModel.locationForRouteList
                )
                coordinatesForPassengerView = await routingViewModel.getCoordinatesFromAddress(for: suggestionsViewModel.locationForRouteList[0])
                    ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
            }
        }
        .overlay(
            GeometryReader { geometry in
                CustomBackButton()
                    .position(x: 25, y: 20)
            }
        )
        .sheet(item: $selectedAnnotation) { annotation in
            CustomAnnotationPopUp(annotation: annotation)
                .presentationBackground(Color.clear)
                .presentationDetents([.medium])
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
