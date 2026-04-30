import SwiftUI

@main
struct AlienContactApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .preferredColorScheme(.dark)
                .onAppear {
                    NotificationService.shared.requestAuthorization { granted in
                        print("Notifications authorized: \(granted)")
                    }
                }
        }
    }
}