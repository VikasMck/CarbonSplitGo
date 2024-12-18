import SwiftUI

@main
struct CarbonSplitGoApp: App {
    //env var is temp until I connect everything via database
    @StateObject private var suggestionsViewModel = SuggestionsViewModel()

    var body: some Scene {
        WindowGroup {
            MainPageView()
                .environmentObject(suggestionsViewModel)
        }
    }
}

#Preview{
    MainPageView()
}
