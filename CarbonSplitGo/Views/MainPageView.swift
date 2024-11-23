import SwiftUI
import MapKit

struct MainPageView: View {
    @StateObject private var mainPageViewModel = MainPageViewModel()
    @State private var searchText = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            Map(position: $mainPageViewModel.userPosition) {
                UserAnnotation()
            }
            
            ContributionsHeaderView()
            
            Spacer()
            
            ControlPanelView()
        }
    }
}

#Preview{
    MainPageView()
}
