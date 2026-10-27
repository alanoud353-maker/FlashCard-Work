import Foundation

struct Scenario: Identifiable {
    let id = UUID()
    let category: String
    let title: String      // "Checking on One’s Day"
    let prompt: String     // "How’s your day going so far?"
    let responses: [String]
}

