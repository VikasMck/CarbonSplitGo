import SwiftUI
import MapKit

struct MainPageView: View {
    @StateObject private var userLocationViewModel = UserLocationViewModel()
    @State private var searchText = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
            ZStack {
                Map(position: $userLocationViewModel.userPosition) {
                    UserAnnotation()
                }
                
                ContributionsHeaderView()
                
                ControlPanelView()
            }.navigationBarHidden(true)
        }
    }


#Preview{
    MainPageView()
        .environmentObject(SuggestionsViewModel())
}
