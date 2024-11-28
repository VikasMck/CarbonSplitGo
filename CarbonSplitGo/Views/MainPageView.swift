import SwiftUI
import MapKit

struct MainPageView: View {
    @StateObject private var userLocationViewModel = UserLocationViewModel()
    @State private var searchText = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        NavigationView{
            ZStack {
                Map(position: $userLocationViewModel.userPosition) {
                    UserAnnotation()
                }
                
                ContributionsHeaderView()
                
                ControlPanelView()
            }
        }
    }
}

#Preview{
    MainPageView()
        .environmentObject(SuggestionsViewModel())
}
