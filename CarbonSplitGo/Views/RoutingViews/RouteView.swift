import SwiftUI
import MapKit

struct RouteView: View {
    @EnvironmentObject var suggestionsViewModel: SuggestionsViewModel
    //at first had all the logic here, but finally fixed so I can follow MVVM again
    @StateObject private var routingViewModel = RoutingViewModel()

    var body: some View {
        VStack {
            
            CustomMapView(routes: routingViewModel.routes)

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
