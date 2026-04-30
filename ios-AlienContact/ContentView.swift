import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
                .accessibilityIdentifier("tab_home")

            MissionsView()
                .tabItem {
                    Label("Missions", systemImage: "airplane.departure")
                }
                .tag(1)
                .accessibilityIdentifier("tab_missions")

            HabitsView()
                .tabItem {
                    Label("Habits", systemImage: "checkmark.circle.fill")
                }
                .tag(2)
                .accessibilityIdentifier("tab_habits")

            ChatView()
                .tabItem {
                    Label("Chat", systemImage: "bubble.left.and.bubble.right.fill")
                }
                .tag(3)
                .accessibilityIdentifier("tab_chat")

            AchievementsView()
                .tabItem {
                    Label("Achievements", systemImage: "star.fill")
                }
                .tag(4)
                .accessibilityIdentifier("tab_achievements")

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(5)
                .accessibilityIdentifier("tab_settings")
        }
        .tint(Color.accentGreen)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
        .preferredColorScheme(.dark)
}