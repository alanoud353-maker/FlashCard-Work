import Foundation
import Observation

@MainActor
@Observable
final class ScenariosViewModel {
    private(set) var scenarios: [Scenario]
    var selectedID: Scenario.ID?
    var practiceScenario: Scenario?

    var selectedIndex: Int? {
        scenarios.firstIndex { $0.id == selectedID }
    }

    var currentPage: Int {
        selectedIndex.map { $0 + 1 } ?? (scenarios.isEmpty ? 0 : 1)
    }

    convenience init() {
        self.init(scenarios: Scenario.examples)
    }

    init(scenarios: [Scenario]) {
        self.scenarios = scenarios
        self.selectedID = scenarios.first?.id
    }

    func selectScenario(id: Scenario.ID) {
        guard scenarios.contains(where: { $0.id == id }) else { return }
        selectedID = id
    }

    func startPractice(for scenario: Scenario) {
        guard let currentScenario = scenarios.first(where: { $0.id == scenario.id }) else { return }
        practiceScenario = currentScenario
    }

    /// Refresh data while preserving selection when its stable ID still exists.
    func updateScenarios(_ scenarios: [Scenario]) {
        self.scenarios = scenarios
        if !scenarios.contains(where: { $0.id == selectedID }) {
            selectedID = scenarios.first?.id
        }
        if let practiceScenario {
            self.practiceScenario = scenarios.first { $0.id == practiceScenario.id }
        }
    }
}
