import SwiftUI
import MapKit

struct MainPageView: View {
    @StateObject private var mainPageViewModel = MainPageViewModel()

    var body: some View {
        Map(position: $mainPageViewModel.userPosition) {
            UserAnnotation()
        }
        .mapControls {
            MapUserLocationButton()

        }
        .onAppear {
            mainPageViewModel.requestLocation()
        }
    }
}

#Preview {
    MainPageView()
}
