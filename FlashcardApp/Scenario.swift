import Foundation

/// Keep IDs stable when loading or updating scenarios from a data source. هنا اعرف انواع المتغيرات
struct Scenario: Identifiable, Codable, Equatable {
    let id: String
    var title: String
    var prompt: String

    // Default scenarios for previews; category data lives in ScenarioCategory.swift.
    static var examples: [Scenario] { ScenarioCategory.icebreakers.scenarios }
}
