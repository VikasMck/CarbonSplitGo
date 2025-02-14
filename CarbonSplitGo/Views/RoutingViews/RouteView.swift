import SwiftUI
import MapKit

struct RouteView: View {
    @EnvironmentObject var suggestionsViewModel: SuggestionsViewModel
    //at first had all the logic here, but finally fixed so I can follow MVVM again
    @StateObject private var routingViewModel = RoutingViewModel()
    @State private var coordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)

    var body: some View {
        ZStack {
            CustomMapView(routes: routingViewModel.routes)
            
            if Session.shared.getUserRole() == "Passenger" {
                PassengerRouteSelect(
                    coordinates: coordinates
                )
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
                coordinates = await routingViewModel.getCoordinatesFromAddress(for: suggestionsViewModel.startingLocationSaved)
                    ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)

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
    }
}

#Preview{
    RouteView()
        .environmentObject(SuggestionsViewModel())
}
