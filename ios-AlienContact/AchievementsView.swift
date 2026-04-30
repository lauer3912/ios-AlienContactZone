import SwiftUI

struct AchievementsView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // XP and Rank
                    VStack(spacing: 8) {
                        Image(systemName: appState.stats.cosmicRank.icon)
                            .font(.system(size: 60))
                            .foregroundColor(AlienTheme.accentGreen)
                        Text(appState.stats.cosmicRank.rawValue)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("Level \(appState.stats.level)")
                            .font(.headline)
                            .foregroundColor(AlienTheme.accentCyan)

                        // XP Progress Bar
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(AlienTheme.surface)
                                    .frame(height: 8)
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(AlienTheme.accentGreen)
                                    .frame(width: geo.size.width * appState.stats.xpProgress, height: 8)
                            }
                        }
                        .frame(height: 8)
                        Text("\(appState.stats.totalXP % 500) / 500 XP to next level")
                            .font(.caption)
                            .foregroundColor(AlienTheme.textSecondary)
                    }
                    .padding()
                    .background(AlienTheme.surface)
                    .cornerRadius(16)

                    // Stats Grid
                    VStack(alignment: .leading, spacing: 12) {
                        Text("YOUR STATS")
                            .font(.caption)
                            .foregroundColor(AlienTheme.textSecondary)
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            AchievementStatBox(title: "Total Stardust", value: "\(appState.stats.totalStardust)", icon: "sparkles", color: AlienTheme.accentPurple)
                            AchievementStatBox(title: "Missions Done", value: "\(appState.stats.totalMissionsCompleted)", icon: "airplane.departure", color: AlienTheme.accentGreen)
                            AchievementStatBox(title: "Best Streak", value: "\(appState.stats.bestStreak)d", icon: "flame.fill", color: .orange)
                            AchievementStatBox(title: "Words Decoded", value: "\(appState.stats.aliensDecoded)", icon: "globe", color: AlienTheme.accentCyan)
                        }
                    }

                    // Achievements List
                    VStack(alignment: .leading, spacing: 8) {
                        Text("ACHIEVEMENTS")
                            .font(.caption)
                            .foregroundColor(AlienTheme.textSecondary)
                        ForEach(appState.achievements) { achievement in
                            AchievementRow(achievement: achievement)
                        }
                    }
                }
                .padding()
            }
            .background(AlienTheme.spaceBlack)
            .navigationTitle("Achievements")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct AchievementStatBox: View {
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

struct AchievementRow: View {
    let achievement: Achievement

    var body: some View {
        HStack {
            Image(systemName: achievement.icon)
                .font(.title2)
                .foregroundColor(achievement.isUnlocked ? AlienTheme.accentGreen : AlienTheme.textSecondary)
                .frame(width: 40)
            VStack(alignment: .leading) {
                Text(achievement.name)
                    .foregroundColor(.white)
                    .fontWeight(.medium)
                Text(achievement.description)
                    .font(.caption)
                    .foregroundColor(AlienTheme.textSecondary)
            }
            Spacer()
            if achievement.isUnlocked {
                Text("+\(achievement.xpReward) XP")
                    .font(.caption)
                    .foregroundColor(AlienTheme.accentCyan)
            } else {
                ProgressView(value: achievement.progress)
                    .frame(width: 60)
                    .tint(AlienTheme.accentGreen)
            }
        }
        .padding()
        .background(AlienTheme.surface)
        .cornerRadius(12)
        .opacity(achievement.isUnlocked ? 1 : 0.7)
    }
}

#Preview {
    AchievementsView()
        .environmentObject(AppState())
        .preferredColorScheme(.dark)
}