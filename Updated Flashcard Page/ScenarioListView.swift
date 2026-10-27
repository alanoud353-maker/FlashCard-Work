import SwiftUI
 
struct ScenarioListView: View {
    // Categories in the order they first appear in Scenario.all
    private var categories: [String] {
        var seen: [String] = []
        for scenario in Scenario.all where !seen.contains(scenario.category) {
            seen.append(scenario.category)
        }
        return seen
    }
 
    var body: some View {
        NavigationStack {
            List {
                ForEach(categories, id: \.self) { category in
                    Section(category) {
                        ForEach(Scenario.all.filter { $0.category == category }) { scenario in
                            NavigationLink(scenario.title) {
                                ContentView(scenario: scenario)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Practice")
        }
    }
}
 
#Preview {
    ScenarioListView()
}
