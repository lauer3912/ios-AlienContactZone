import SwiftUI

struct MissionsView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingAddMission = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Mission Stats
                    HStack(spacing: 12) {
                        MiniStatCard(title: "Total", value: "\(appState.stats.totalMissionsCompleted)", color: .white)
                        MiniStatCard(title: "Streak", value: "\(appState.stats.currentStreak)d", color: AlienTheme.accentGreen)
                        MiniStatCard(title: "Today", value: "\(appState.todaySummary.missionsCompleted)", color: AlienTheme.accentCyan)
                    }

                    // Active Mission
                    if let active = appState.missions.first(where: { !$0.isCompleted && !$0.isSkipped }) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("ACTIVE MISSION")
                                .font(.caption)
                                .foregroundColor(AlienTheme.accentGreen)
                            ActiveMissionCard(mission: active)
                        }
                    }

                    // All Missions
                    VStack(alignment: .leading, spacing: 8) {
                        Text("ALL MISSIONS")
                            .font(.caption)
                            .foregroundColor(AlienTheme.textSecondary)
                        ForEach(appState.missions) { mission in
                            MissionRow(mission: mission)
                        }
                    }
                }
                .padding()
            }
            .background(AlienTheme.spaceBlack)
            .navigationTitle("Missions")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddMission = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(AlienTheme.accentGreen)
                    }
                }
            }
            .sheet(isPresented: $showingAddMission) {
                AddMissionView()
            }
        }
    }
}

struct MiniStatCard: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            Text(title)
                .font(.caption2)
                .foregroundColor(AlienTheme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(AlienTheme.surface)
        .cornerRadius(10)
    }
}

struct ActiveMissionCard: View {
    let mission: Mission
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: mission.category.icon)
                    .font(.title)
                    .foregroundColor(mission.category.color)
                VStack(alignment: .leading) {
                    Text(mission.title)
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(mission.description)
                        .font(.subheadline)
                        .foregroundColor(AlienTheme.textSecondary)
                }
            }
            HStack {
                Label("\(mission.duration) min", systemImage: "clock", image: "")
                    .font(.caption)
                    .foregroundColor(AlienTheme.textSecondary)
                Spacer()
                Label("\(mission.stardustReward)", systemImage: "sparkles", image: "")
                    .font(.caption)
                    .foregroundColor(AlienTheme.accentPurple)
                Label("\(mission.xpReward) XP", systemImage: "star.fill", image: "")
                    .font(.caption)
                    .foregroundColor(AlienTheme.accentCyan)
            }
            HStack(spacing: 12) {
                Button {
                    appState.completeMission(mission)
                } label: {
                    Label("Complete", systemImage: "checkmark.circle.fill")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(AlienTheme.accentGreen)
                        .foregroundColor(.black)
                        .cornerRadius(12)
                }
                Button {
                    appState.skipMission(mission)
                } label: {
                    Label("Skip", systemImage: "forward.fill")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(AlienTheme.surface)
                        .foregroundColor(AlienTheme.textSecondary)
                        .cornerRadius(12)
                }
            }
        }
        .padding()
        .background(AlienTheme.surface)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AlienTheme.accentGreen.opacity(0.5), lineWidth: 1)
        )
        .cornerRadius(16)
    }
}

struct MissionRow: View {
    let mission: Mission

    var body: some View {
        HStack {
            Image(systemName: mission.category.icon)
                .foregroundColor(mission.category.color)
                .frame(width: 30)
            VStack(alignment: .leading) {
                Text(mission.title)
                    .foregroundColor(.white)
                Text(mission.difficulty.rawValue)
                    .font(.caption)
                    .foregroundColor(mission.difficulty.color)
            }
            Spacer()
            if mission.isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(AlienTheme.accentGreen)
            } else if mission.isSkipped {
                Image(systemName: "forward.fill")
                    .foregroundColor(AlienTheme.textSecondary)
            } else {
                Text("\(mission.stardustReward) ✨")
                    .font(.caption)
                    .foregroundColor(AlienTheme.accentPurple)
            }
        }
        .padding()
        .background(AlienTheme.surface)
        .cornerRadius(12)
    }
}

struct AddMissionView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var description = ""
    @State private var difficulty: MissionDifficulty = .medium
    @State private var category: MissionCategory = .focus

    var body: some View {
        NavigationStack {
            Form {
                TextField("Mission Title", text: $title)
                TextField("Description", text: $description)
                Picker("Difficulty", selection: $difficulty) {
                    ForEach(MissionDifficulty.allCases, id: \.self) { d in
                        Text(d.rawValue).tag(d)
                    }
                }
                Picker("Category", selection: $category) {
                    ForEach(MissionCategory.allCases, id: \.self) { c in
                        Label(c.rawValue, systemImage: c.icon).tag(c)
                    }
                }
            }
            .navigationTitle("New Mission")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let mission = Mission(title: title, description: description, difficulty: difficulty, category: category)
                        appState.addMission(mission)
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}

#Preview {
    MissionsView()
        .environmentObject(AppState())
        .preferredColorScheme(.dark)
}