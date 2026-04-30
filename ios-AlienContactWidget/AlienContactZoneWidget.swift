import WidgetKit
import SwiftUI

struct AlienWidgetEntry: TimelineEntry {
    let date: Date
    let missionsCompleted: Int
    let habitsCompleted: Int
    let currentStreak: Int
}

struct AlienWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> AlienWidgetEntry {
        AlienWidgetEntry(date: Date(), missionsCompleted: 0, habitsCompleted: 0, currentStreak: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (AlienWidgetEntry) -> Void) {
        let entry = AlienWidgetEntry(date: Date(), missionsCompleted: 3, habitsCompleted: 5, currentStreak: 7)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<AlienWidgetEntry>) -> Void) {
        let entry = AlienWidgetEntry(date: Date(), missionsCompleted: 0, habitsCompleted: 0, currentStreak: 0)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct AlienWidgetEntryView: View {
    var entry: AlienWidgetProvider.Entry

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "airplane.departure")
                    .foregroundColor(Color(hex: "00FF88"))
                Text("Alien Contact Zone")
                    .font(.caption)
                    .foregroundColor(.white)
            }
            HStack(spacing: 16) {
                VStack {
                    Text("\(entry.missionsCompleted)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text("Missions")
                        .font(.caption2)
                        .foregroundColor(Color(hex: "8E8E93"))
                }
                VStack {
                    Text("\(entry.habitsCompleted)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text("Habits")
                        .font(.caption2)
                        .foregroundColor(Color(hex: "8E8E93"))
                }
                VStack {
                    Text("\(entry.currentStreak)d")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "00FF88"))
                    Text("Streak")
                        .font(.caption2)
                        .foregroundColor(Color(hex: "8E8E93"))
                }
            }
        }
        .padding(16)
        .background(Color(hex: "0F0F14"))
    }
}

@main
struct AlienContactZoneWidget: Widget {
    let kind: String = "AlienContactZoneWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: AlienWidgetProvider()) { entry in
            AlienWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Alien Contact Zone")
        .description("Track your daily progress")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 6:
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: 1)
    }
}