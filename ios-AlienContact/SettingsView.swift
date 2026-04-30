import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationStack {
            Form {
                Section("Appearance") {
                    Toggle("Dark Mode", isOn: .constant(true))
                        .disabled(true)
                    Text("Dark mode is always on")
                        .font(.caption)
                        .foregroundColor(AlienTheme.textSecondary)
                }
                .listRowBackground(AlienTheme.surface)

                Section("Notifications") {
                    Toggle("Enable Notifications", isOn: $appState.settings.notificationsEnabled)
                    DatePicker("Daily Reminder", displayedBindingSelection: .constant(.constant(Date())) {
                        Text("Time")
                    }
                }
                .listRowBackground(AlienTheme.surface)

                Section("Sound") {
                    Toggle("Sound Effects", isOn: $appState.settings.soundEnabled)
                }
                .listRowBackground(AlienTheme.surface)

                Section("Goals") {
                    Stepper("Daily Focus Goal: \(appState.settings.dailyFocusGoal) min", value: $appState.settings.dailyFocusGoal, in: 15...180, step: 15)
                }
                .listRowBackground(AlienTheme.surface)

                Section("Support") {
                    Link(destination: URL(string: "mailto:lauer3912@qq.com")!) {
                        HStack {
                            Text("Contact Support")
                                .foregroundColor(.white)
                            Spacer()
                            Text("lauer3912@qq.com")
                                .foregroundColor(AlienTheme.textSecondary)
                        }
                    }
                    Link(destination: URL(string: "https://lauer3912.github.io/ios-AlienContactZone/PrivacyPolicy.html")!) {
                        HStack {
                            Text("Privacy Policy")
                                .foregroundColor(.white)
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .foregroundColor(AlienTheme.textSecondary)
                        }
                    }
                }
                .listRowBackground(AlienTheme.surface)

                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(AlienTheme.textSecondary)
                    }
                    HStack {
                        Text("Developer")
                        Spacer()
                        Text("PageBrin")
                            .foregroundColor(AlienTheme.textSecondary)
                    }
                }
                .listRowBackground(AlienTheme.surface)
            }
            .scrollContentBackground(.hidden)
            .background(AlienTheme.spaceBlack)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppState())
        .preferredColorScheme(.dark)
}