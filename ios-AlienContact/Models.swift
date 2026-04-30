import SwiftUI

// MARK: - App Theme Colors
struct AlienTheme {
    static let spaceBlack = Color(hex: "0F0F14")
    static let deepSpace = Color(hex: "1a1a2e")
    static let accentGreen = Color(hex: "00FF88")
    static let accentPurple = Color(hex: "9B59FF")
    static let accentCyan = Color(hex: "00D4FF")
    static let textPrimary = Color.white
    static let textSecondary = Color(hex: "8E8E93")
    static let surface = Color(hex: "2C2C3E")
    static let destructive = Color(hex: "FF4757")
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Mission Model
struct Mission: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String
    var difficulty: MissionDifficulty
    var category: MissionCategory
    var startTime: Date
    var duration: Int // minutes
    var stardustReward: Int
    var xpReward: Int
    var isCompleted: Bool
    var isSkipped: Bool
    var completedAt: Date?

    init(id: UUID = UUID(), title: String, description: String, difficulty: MissionDifficulty, category: MissionCategory, startTime: Date = Date(), duration: Int = 30, stardustReward: Int = 100, xpReward: Int = 50) {
        self.id = id
        self.title = title
        self.description = description
        self.difficulty = difficulty
        self.category = category
        self.startTime = startTime
        self.duration = duration
        self.stardustReward = stardustReward
        self.xpReward = xpReward
        self.isCompleted = false
        self.isSkipped = false
        self.completedAt = nil
    }
}

enum MissionDifficulty: String, Codable, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    case impossible = "Impossible"

    var color: Color {
        switch self {
        case .easy: return .green
        case .medium: return .yellow
        case .hard: return .orange
        case .impossible: return .red
        }
    }

    var multiplier: Double {
        switch self {
        case .easy: return 1.0
        case .medium: return 1.5
        case .hard: return 2.0
        case .impossible: return 3.0
        }
    }
}

enum MissionCategory: String, Codable, CaseIterable {
    case focus = "Focus"
    case fitness = "Fitness"
    case learn = "Learn"
    case create = "Create"
    case connect = "Connect"

    var icon: String {
        switch self {
        case .focus: return "brain.head.profile"
        case .fitness: return "figure.run"
        case .learn: return "book.fill"
        case .create: return "paintbrush.fill"
        case .connect: return "person.2.fill"
        }
    }

    var color: Color {
        switch self {
        case .focus: return AlienTheme.accentCyan
        case .fitness: return AlienTheme.accentGreen
        case .learn: return AlienTheme.accentPurple
        case .create: return .orange
        case .connect: return .pink
        }
    }
}

// MARK: - Habit Model
struct Habit: Identifiable, Codable {
    let id: UUID
    var name: String
    var icon: String
    var frequency: HabitFrequency
    var category: HabitCategory
    var createdAt: Date
    var completedDates: [Date]
    var currentStreak: Int
    var bestStreak: Int

    var isCompletedToday: Bool {
        completedDates.contains { Calendar.current.isDateInToday($0) }
    }

    init(id: UUID = UUID(), name: String, icon: String = "star.fill", frequency: HabitFrequency = .daily, category: HabitCategory = .mind) {
        self.id = id
        self.name = name
        self.icon = icon
        self.frequency = frequency
        self.category = category
        self.createdAt = Date()
        self.completedDates = []
        self.currentStreak = 0
        self.bestStreak = 0
    }
}

enum HabitFrequency: String, Codable, CaseIterable {
    case daily = "Daily"
    case weekdays = "Weekdays"
    case weekly = "Weekly"
    case custom = "Custom"
}

enum HabitCategory: String, Codable, CaseIterable {
    case mind = "Mind"
    case body = "Body"
    case soul = "Soul"
    case social = "Social"

    var color: Color {
        switch self {
        case .mind: return AlienTheme.accentCyan
        case .body: return AlienTheme.accentGreen
        case .soul: return AlienTheme.accentPurple
        case .social: return .pink
        }
    }

    var icon: String {
        switch self {
        case .mind: return "brain"
        case .body: return "figure.walk"
        case .soul: return "moon.stars"
        case .social: return "person.2"
        }
    }
}

// MARK: - Achievement Model
struct Achievement: Identifiable, Codable {
    let id: String
    var name: String
    var description: String
    var icon: String
    var category: String
    var xpReward: Int
    var isUnlocked: Bool
    var unlockedAt: Date?
    var progress: Double // 0.0 to 1.0

    init(id: String, name: String, description: String, icon: String, category: String, xpReward: Int) {
        self.id = id
        self.name = name
        self.description = description
        self.icon = icon
        self.category = category
        self.xpReward = xpReward
        self.isUnlocked = false
        self.unlockedAt = nil
        self.progress = 0.0
    }
}

// MARK: - Alien NPC Model
struct AlienNPC: Identifiable {
    let id: String
    var name: String
    var avatar: String
    var role: String
    var mood: NPCMood
    var isUnlocked: Bool
    var level: Int

    init(id: String, name: String, avatar: String, role: String, mood: NPCMood = .neutral, isUnlocked: Bool = true, level: Int = 1) {
        self.id = id
        self.name = name
        self.avatar = avatar
        self.role = role
        self.mood = mood
        self.isUnlocked = isUnlocked
        self.level = level
    }
}

enum NPCMood: String, Codable {
    case happy = "Happy"
    case neutral = "Neutral"
    case sad = "Sad"
    case excited = "Excited"
    case concerned = "Concerned"
}

// MARK: - Chat Message
struct ChatMessage: Identifiable, Codable {
    let id: UUID
    let npcId: String
    let text: String
    let timestamp: Date
    let isFromUser: Bool

    init(id: UUID = UUID(), npcId: String, text: String, timestamp: Date = Date(), isFromUser: Bool = false) {
        self.id = id
        self.npcId = npcId
        self.text = text
        self.timestamp = timestamp
        self.isFromUser = isFromUser
    }
}

// MARK: - App Settings
struct AppSettings: Codable {
    var soundEnabled: Bool = true
    var notificationsEnabled: Bool = true
    var notificationTime: Date = Calendar.current.date(from: DateComponents(hour: 9, minute: 0)) ?? Date()
    var isDarkMode: Bool = true
    var dailyFocusGoal: Int = 60
}

// MARK: - User Stats
struct UserStats: Codable {
    var totalXP: Int = 0
    var level: Int = 1
    var totalStardust: Int = 0
    var totalMissionsCompleted: Int = 0
    var totalHabitsCompleted: Int = 0
    var currentStreak: Int = 0
    var bestStreak: Int = 0
    var aliensDecoded: Int = 0
    var cosmicRank: CosmicRank = .recruit

    var xpForNextLevel: Int {
        level * 500
    }

    var xpProgress: Double {
        Double(totalXP % 500) / Double(xpForNextLevel)
    }
}

enum CosmicRank: String, Codable, CaseIterable {
    case recruit = "Space Recruit"
    case cadet = "Cosmic Cadet"
    case explorer = "Star Explorer"
    case commander = "Galaxy Commander"
    case admiral = "Cosmic Admiral"

    var icon: String {
        switch self {
        case .recruit: return "star"
        case .cadet: return "star.leadinghalf.filled"
        case .explorer: return "star.fill"
        case .commander: return "star.circle.fill"
        case .admiral: return "sparkles"
        }
    }
}

// MARK: - Alien Language
struct DecodedWord: Identifiable, Codable {
    let id: UUID
    var word: String
    var meaning: String
    var decodedAt: Date
    var letterCount: Int

    init(id: UUID = UUID(), word: String, meaning: String, letterCount: Int) {
        self.id = id
        self.word = word
        self.meaning = meaning
        self.decodedAt = Date()
        self.letterCount = letterCount
    }
}

// MARK: - Daily Summary
struct DailySummary {
    var date: Date
    var missionsCompleted: Int = 0
    var habitsCompleted: Int = 0
    var xpEarned: Int = 0
    var stardustEarned: Int = 0
    var focusMinutes: Int = 0
}