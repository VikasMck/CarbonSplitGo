import SwiftUI
import MapKit

struct RouteView: View {
    @EnvironmentObject var suggestionsViewModel: SuggestionsViewModel
    //at first had all the logic here, but finally fixed so I can follow MVVM again
    @StateObject private var routingViewModel = RoutingViewModel()

    var body: some View {
        VStack {
            CustomMapView(routes: routingViewModel.routes)

            ForEach(0..<routingViewModel.userCoordinates.count, id: \.self) { index in
                if let coordinate = routingViewModel.userCoordinates[index] {
                    Text("Coordinates \(index + 1): \(coordinate.latitude), \(coordinate.longitude)")
                }
            }
        }
        .onAppear {
            Task {
                await routingViewModel.fetchCoordinates(from: [
                    //this remains hard coded still, will need to change the logic to depend on how many users, etc
                    suggestionsViewModel.startingLocationSaved,
                    suggestionsViewModel.middleLocationSaved,
                    suggestionsViewModel.endLocationSaved
                ])
            }
        }
    }
}

#Preview{
    RouteView()
        .environmentObject(SuggestionsViewModel())
}
