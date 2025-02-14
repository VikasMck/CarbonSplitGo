import SwiftUI

@main
struct CarbonSplitGoApp: App {
    @StateObject private var suggestionsViewModel = SuggestionsViewModel()
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            AuthenticateView()
                .environmentObject(suggestionsViewModel)
                .onAppear {
                    print("App started.")
                    BackgroundTask.registerBackgroundTasks()
                }
                .onChange(of: scenePhase, initial: true) { oldPhase, newPhase in
                    print("scenePhase changed from \(String(describing: oldPhase)) to \(newPhase)")
                    BackgroundTask.handleScenePhaseChange(newPhase)
                }
        }
    }
}

#Preview{
    AuthenticateView()
        .environmentObject(SuggestionsViewModel())
}
