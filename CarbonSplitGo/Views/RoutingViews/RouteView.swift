import SwiftUI
import MapKit

struct RouteView: View {
    @EnvironmentObject var suggestionsViewModel: SuggestionsViewModel
    //at first had all the logic here, but finally fixed so I can follow MVVM again
    @StateObject private var routingViewModel = RoutingViewModel()
    @State private var coordinatesForPassengerView: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    @State private var annotations: [MKPointAnnotation] = []
    @State private var selectedAnnotation: MKPointAnnotation?

    var body: some View {
        ZStack {

            CustomMapView(routes: routingViewModel.routes, annotations: $annotations, selectedAnnotation: $selectedAnnotation)

            if Session.shared.getUserRole() == "Passenger" {
                PassengerRouteSelectView(coordinates: coordinatesForPassengerView)
            }
            else if Session.shared.getUserRole() == "Driver" {
                DriverRouteSelectView(annotations: $annotations) {
                    fetchedUserCoordinates in let fetchedAnnotation = MKPointAnnotation()
                    fetchedAnnotation.coordinate = fetchedUserCoordinates
                    annotations.append(fetchedAnnotation)
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            if suggestionsViewModel.startingLocationSaved == "My Location" {
                suggestionsViewModel.startingLocationSaved = Session.shared.getUserOriginalLocation()!
            }
            Task {
                await routingViewModel.fetchCoordinates(from: [
                    suggestionsViewModel.startingLocationSaved,
                    suggestionsViewModel.endLocationSaved
                ])
                //I hope this way doesn't hurt me later
                coordinatesForPassengerView = await routingViewModel.getCoordinatesFromAddress(for: suggestionsViewModel.startingLocationSaved)
                    ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
                
                annotations = routingViewModel.generateAnnotations()
                
                suggestionsViewModel.startingLocationSaved = ""
                suggestionsViewModel.endLocationSaved = ""
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
