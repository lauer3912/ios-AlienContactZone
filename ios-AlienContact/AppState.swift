import SwiftUI

class AppState: ObservableObject {
    @Published var selectedTab: Tab = .home
    @Published var missions: [Mission] = []
    @Published var habits: [Habit] = []
    @Published var achievements: [Achievement] = []
    @Published var npcs: [AlienNPC] = []
    @Published var chatMessages: [ChatMessage] = []
    @Published var decodedWords: [DecodedWord] = []
    @Published var stats: UserStats = UserStats()
    @Published var settings: AppSettings = AppSettings()
    @Published var todaySummary: DailySummary = DailySummary(date: Date())

    enum Tab: String, CaseIterable {
        case home = "Home"
        case missions = "Missions"
        case habits = "Habits"
        case chat = "Chat"
        case achievements = "Achievements"
        case settings = "Settings"
    }

    init() {
        loadDefaultData()
    }

    private func loadDefaultData() {
        // Default NPCs
        npcs = [
            AlienNPC(id: "zorp", name: "Zorp", avatar: "🛸", role: "Mission Advisor"),
            AlienNPC(id: "nebula", name: "Nebula", avatar: "🌌", role: "Mood Tracker"),
            AlienNPC(id: "cosmo", name: "Cosmo", avatar: "✨", role: "Motivator")
        ]

        // Default Achievements
        achievements = [
            Achievement(id: "first_mission", name: "First Contact", description: "Complete your first mission", icon: "airplane", category: "Missions", xpReward: 100),
            Achievement(id: "streak_7", name: "Week Warrior", description: "7 day streak", icon: "flame.fill", category: "Streaks", xpReward: 250),
            Achievement(id: "streak_30", name: "Cosmic Commitment", description: "30 day streak", icon: "sparkles", category: "Streaks", xpReward: 500),
            Achievement(id: "missions_10", name: "Mission Master", description: "Complete 10 missions", icon: "medal.fill", category: "Missions", xpReward: 300),
            Achievement(id: "habits_10", name: "Habit Former", description: "Create 10 habits", icon: "checkmark.seal.fill", category: "Habits", xpReward: 200),
            Achievement(id: "decode_5", name: "Language Learner", description: "Decode 5 alien words", icon: "globe", category: "Language", xpReward: 150),
            Achievement(id: "level_5", name: "Rising Star", description: "Reach level 5", icon: "star.fill", category: "XP", xpReward: 400),
            Achievement(id: "all_categories", name: "Well Rounded", description: "Complete missions in all categories", icon: "square.grid.2x2.fill", category: "Missions", xpReward: 350),
        ]

        // Sample missions
        missions = [
            Mission(title: "Meditation Mission", description: "Complete a 10-minute meditation session", difficulty: .easy, category: .focus, duration: 15, stardustReward: 100, xpReward: 50),
            Mission(title: "Learn Something New", description: "Watch an educational video or read an article", difficulty: .medium, category: .learn, duration: 20, stardustReward: 150, xpReward: 75),
            Mission(title: "Workout Warrior", description: "Complete a 30-minute workout", difficulty: .hard, category: .fitness, duration: 45, stardustReward: 250, xpReward: 100),
            Mission(title: "Creative Burst", description: "Draw, write, or create something for 20 minutes", difficulty: .medium, category: .create, duration: 25, stardustReward: 150, xpReward: 75),
        ]

        // Sample habits
        habits = [
            Habit(name: "Morning Meditation", icon: "brain", frequency: .daily, category: .mind),
            Habit(name: "Exercise", icon: "figure.run", frequency: .daily, category: .body),
            Habit(name: "Read 30 minutes", icon: "book.fill", frequency: .daily, category: .mind),
            Habit(name: "Drink 8 glasses water", icon: "drop.fill", frequency: .daily, category: .body),
        ]
    }

    func completeMission(_ mission: Mission) {
        if let index = missions.firstIndex(where: { $0.id == mission.id }) {
            missions[index].isCompleted = true
            missions[index].completedAt = Date()
            stats.totalMissionsCompleted += 1
            stats.totalStardust += mission.stardustReward
            stats.totalXP += mission.xpReward
            checkLevelUp()
            todaySummary.missionsCompleted += 1
            todaySummary.stardustEarned += mission.stardustReward
            todaySummary.xpEarned += mission.xpReward
        }
    }

    func skipMission(_ mission: Mission) {
        if let index = missions.firstIndex(where: { $0.id == mission.id }) {
            missions[index].isSkipped = true
        }
    }

    func completeHabit(_ habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            if !habits[index].isCompletedToday {
                habits[index].completedDates.append(Date())
                updateStreak(&habits[index])
                stats.totalHabitsCompleted += 1
                checkLevelUp()
                todaySummary.habitsCompleted += 1
            }
        }
    }

    private func updateStreak(_ habit: inout Habit) {
        let calendar = Calendar.current
        habit.currentStreak += 1
        if habit.currentStreak > habit.bestStreak {
            habit.bestStreak = habit.currentStreak
        }
    }

    private func checkLevelUp() {
        let xpForNext = stats.level * 500
        if stats.totalXP >= xpForNext {
            stats.level += 1
            stats.currentStreak += 1
            if stats.currentStreak > stats.bestStreak {
                stats.bestStreak = stats.currentStreak
            }
            updateCosmicRank()
        }
    }

    private func updateCosmicRank() {
        switch stats.level {
        case 1..<5: stats.cosmicRank = .recruit
        case 5..<10: stats.cosmicRank = .cadet
        case 10..<20: stats.cosmicRank = .explorer
        case 20..<30: stats.cosmicRank = .commander
        default: stats.cosmicRank = .admiral
        }
    }

    func addHabit(_ habit: Habit) {
        habits.append(habit)
    }

    func addMission(_ mission: Mission) {
        missions.append(mission)
    }

    func sendChatMessage(_ text: String, npcId: String) {
        let userMsg = ChatMessage(npcId: npcId, text: text, isFromUser: true)
        chatMessages.append(userMsg)

        // Simulate alien NPC response
        let responses = [
            "🛸 Greetings, Earth friend! Your dedication is noted by the cosmos.",
            "🌌 Interesting choice! The stars align in your favor today.",
            "✨ We observe your progress with great interest. Keep going!",
            "👽 The alien council is pleased with your efforts.",
            "🌠 Your mission awareness has increased by 47%. Impressive!"
        ]
        let botMsg = ChatMessage(npcId: npcId, text: responses.randomElement()!, isFromUser: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.chatMessages.append(botMsg)
        }
    }
}