import XCTest

final class AlienContactZoneTests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testAppStateCreation() throws {
        let appState = AppState()
        XCTAssertFalse(appState.missions.isEmpty, "Should have default missions")
        XCTAssertFalse(appState.habits.isEmpty, "Should have default habits")
        XCTAssertFalse(appState.npcs.isEmpty, "Should have default NPCs")
    }

    func testCompleteMission() throws {
        let appState = AppState()
        let initialMissions = appState.stats.totalMissionsCompleted
        if let mission = appState.missions.first {
            appState.completeMission(mission)
            XCTAssertEqual(appState.stats.totalMissionsCompleted, initialMissions + 1)
        }
    }

    func testCompleteHabit() throws {
        let appState = AppState()
        let initialHabits = appState.stats.totalHabitsCompleted
        if let habit = appState.habits.first {
            appState.completeHabit(habit)
            XCTAssertEqual(appState.stats.totalHabitsCompleted, initialHabits + 1)
        }
    }
}