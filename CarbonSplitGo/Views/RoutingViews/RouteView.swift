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
                if routingViewModel.userCoordinates[index] != nil {
//                    Text("Coordinates \(index + 1): \(coordinate.latitude), \(coordinate.longitude)")
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            Task {
                await routingViewModel.fetchCoordinates(from: [
                    suggestionsViewModel.startingLocationSaved,
//                    suggestionsViewModel.middleLocationSaved,
                    suggestionsViewModel.endLocationSaved
                ])
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
