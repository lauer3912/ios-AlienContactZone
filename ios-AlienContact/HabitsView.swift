import SwiftUI

struct HabitsView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingAddHabit = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Stats
                    HStack(spacing: 12) {
                        MiniStatCard(title: "Total", value: "\(appState.stats.totalHabitsCompleted)", color: .white)
                        MiniStatCard(title: "Streak", value: "\(appState.stats.currentStreak)d", color: AlienTheme.accentGreen)
                        MiniStatCard(title: "Today", value: "\(appState.habits.filter { $0.isCompletedToday }.count)", color: AlienTheme.accentCyan)
                    }

                    // Progress Ring
                    let completed = appState.habits.filter { $0.isCompletedToday }.count
                    let total = appState.habits.count
                    if total > 0 {
                        VStack {
                            ZStack {
                                Circle()
                                    .stroke(AlienTheme.surface, lineWidth: 12)
                                Circle()
                                    .trim(from: 0, to: CGFloat(completed) / CGFloat(total))
                                    .stroke(AlienTheme.accentGreen, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                                    .rotationEffect(.degrees(-90))
                                VStack {
                                    Text("\(completed)/\(total)")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    Text("Today")
                                        .font(.caption)
                                        .foregroundColor(AlienTheme.textSecondary)
                                }
                            }
                            .frame(width: 120, height: 120)
                        }
                        .padding()
                    }

                    // Habits List
                    VStack(alignment: .leading, spacing: 8) {
                        Text("YOUR HABITS")
                            .font(.caption)
                            .foregroundColor(AlienTheme.textSecondary)
                        ForEach(appState.habits) { habit in
                            HabitRow(habit: habit)
                        }
                    }
                }
                .padding()
            }
            .background(AlienTheme.spaceBlack)
            .navigationTitle("Habits")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddHabit = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(AlienTheme.accentGreen)
                    }
                }
            }
            .sheet(isPresented: $showingAddHabit) {
                AddHabitView()
            }
        }
    }
}

struct HabitRow: View {
    let habit: Habit
    @EnvironmentObject var appState: AppState

    var body: some View {
        HStack {
            Image(systemName: habit.icon)
                .foregroundColor(habit.category.color)
                .frame(width: 30)
            VStack(alignment: .leading) {
                Text(habit.name)
                    .foregroundColor(.white)
                HStack {
                    Text("🔥 \(habit.currentStreak)d streak")
                        .font(.caption)
                        .foregroundColor(AlienTheme.accentGreen)
                    Text("\(habit.category.rawValue)")
                        .font(.caption)
                        .foregroundColor(habit.category.color)
                }
            }
            Spacer()
            Button {
                appState.completeHabit(habit)
            } label: {
                Image(systemName: habit.isCompletedToday ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(habit.isCompletedToday ? AlienTheme.accentGreen : AlienTheme.textSecondary)
                    .font(.title2)
            }
        }
        .padding()
        .background(AlienTheme.surface)
        .cornerRadius(12)
    }
}

struct AddHabitView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var icon = "star.fill"
    @State private var category: HabitCategory = .mind

    let icons = ["star.fill", "book.fill", "figure.run", "moon.stars", "person.2", "brain", "leaf.fill", "drop.fill"]

    var body: some View {
        NavigationStack {
            Form {
                TextField("Habit Name", text: $name)
                Picker("Category", selection: $category) {
                    ForEach(HabitCategory.allCases, id: \.self) { c in
                        Label(c.rawValue, systemImage: c.icon).tag(c)
                    }
                }
                HStack {
                    ForEach(icons, id: \.self) { iconName in
                        Button {
                            icon = iconName
                        } label: {
                            Image(systemName: iconName)
                                .foregroundColor(icon == iconName ? AlienTheme.accentGreen : AlienTheme.textSecondary)
                                .padding(8)
                                .background(icon == iconName ? AlienTheme.surface : Color.clear)
                                .cornerRadius(8)
                        }
                    }
                }
            }
            .navigationTitle("New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let habit = Habit(name: name, icon: icon, category: category)
                        appState.addHabit(habit)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}

#Preview {
    HabitsView()
        .environmentObject(AppState())
        .preferredColorScheme(.dark)
}