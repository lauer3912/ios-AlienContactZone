import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Cosmic Rank Header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Image(systemName: appState.stats.cosmicRank.icon)
                                    .foregroundColor(AlienTheme.accentGreen)
                                Text(appState.stats.cosmicRank.rawValue)
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                            Text("Level \(appState.stats.level)")
                                .font(.subheadline)
                                .foregroundColor(AlienTheme.textSecondary)
                        }
                        Spacer()
                        // XP Progress
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("\(appState.stats.totalXP) XP")
                                .font(.subheadline)
                                .foregroundColor(AlienTheme.accentCyan)
                            Text("\(appState.stats.totalXP % 500)/500")
                                .font(.caption)
                                .foregroundColor(AlienTheme.textSecondary)
                        }
                    }
                    .padding()
                    .background(AlienTheme.surface)
                    .cornerRadius(16)

                    // Daily Summary
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Today's Progress")
                            .font(.headline)
                            .foregroundColor(.white)
                        HStack(spacing: 16) {
                            StatCard(title: "Missions", value: "\(appState.todaySummary.missionsCompleted)", icon: "airplane.departure", color: AlienTheme.accentGreen)
                            StatCard(title: "Habits", value: "\(appState.todaySummary.habitsCompleted)", icon: "checkmark.circle.fill", color: AlienTheme.accentCyan)
                            StatCard(title: "Stardust", value: "\(appState.todaySummary.stardustEarned)", icon: "sparkles", color: AlienTheme.accentPurple)
                        }
                    }

                    // Current Mission
                    if let activeMission = appState.missions.first(where: { !$0.isCompleted && !$0.isSkipped }) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Current Mission")
                                .font(.headline)
                                .foregroundColor(.white)
                            MissionCard(mission: activeMission)
                        }
                    }

                    // Quick Habits
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Today's Habits")
                            .font(.headline)
                            .foregroundColor(.white)
                        ForEach(appState.habits.prefix(3)) { habit in
                            HabitQuickRow(habit: habit) {
                                appState.completeHabit(habit)
                            }
                        }
                    }

                    // Recent Achievement
                    if let recentAchievement = appState.achievements.first(where: { $0.isUnlocked }) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Recent Achievement")
                                .font(.headline)
                                .foregroundColor(.white)
                            HStack {
                                Image(systemName: recentAchievement.icon)
                                    .font(.title2)
                                    .foregroundColor(AlienTheme.accentGreen)
                                VStack(alignment: .leading) {
                                    Text(recentAchievement.name)
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                    Text(recentAchievement.description)
                                        .font(.caption)
                                        .foregroundColor(AlienTheme.textSecondary)
                                }
                                Spacer()
                                Text("+\(recentAchievement.xpReward) XP")
                                    .font(.caption)
                                    .foregroundColor(AlienTheme.accentCyan)
                            }
                            .padding()
                            .background(AlienTheme.surface)
                            .cornerRadius(12)
                        }
                    }
                }
                .padding()
            }
            .background(AlienTheme.spaceBlack)
            .navigationTitle("Alien Contact Zone")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(AlienTheme.spaceBlack, for: .navigationBar)
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Text(title)
                .font(.caption)
                .foregroundColor(AlienTheme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(AlienTheme.surface)
        .cornerRadius(12)
    }
}

struct MissionCard: View {
    let mission: Mission

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: mission.category.icon)
                    .foregroundColor(mission.category.color)
                Text(mission.title)
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Text(mission.difficulty.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(mission.difficulty.color.opacity(0.2))
                    .foregroundColor(mission.difficulty.color)
                    .cornerRadius(8)
            }
            Text(mission.description)
                .font(.subheadline)
                .foregroundColor(AlienTheme.textSecondary)
            HStack {
                Label("\(mission.duration) min", systemImage: "clock")
                Spacer()
                Label("\(mission.stardustReward) ✨", systemImage: "sparkles")
                Label("\(mission.xpReward) XP", systemImage: "star.fill")
            }
            .font(.caption)
            .foregroundColor(AlienTheme.textSecondary)
        }
        .padding()
        .background(AlienTheme.surface)
        .cornerRadius(16)
    }
}

struct HabitQuickRow: View {
    let habit: Habit
    let onComplete: () -> Void

    var body: some View {
        HStack {
            Image(systemName: habit.icon)
                .foregroundColor(habit.category.color)
                .frame(width: 30)
            Text(habit.name)
                .foregroundColor(.white)
            Spacer()
            if habit.isCompletedToday {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(AlienTheme.accentGreen)
            } else {
                Button {
                    onComplete()
                } label: {
                    Image(systemName: "circle")
                        .foregroundColor(AlienTheme.textSecondary)
                }
            }
        }
        .padding()
        .background(AlienTheme.surface)
        .cornerRadius(12)
    }
}

#Preview {
    HomeView()
        .environmentObject(AppState())
        .preferredColorScheme(.dark)
}