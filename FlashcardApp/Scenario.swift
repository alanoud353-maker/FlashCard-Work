import Foundation

/// Keep IDs stable when loading or updating scenarios from a data source. هنا اعرف انواع المتغيرات
struct Scenario: Identifiable, Codable, Equatable {
    let id: String
    var title: String
    var prompt: String

    // Add your own scenarios here, or pass a different array to ScenariosViewModel. هنا في array للبيانات الداخليه
    static let examples: [Scenario] = [
        Scenario(id: "meeting", title: "Recommendation", prompt: "What’s a good restaurant you know? I’ve been wanting to try a new spot."),
        Scenario(id: "work", title: "Shared Situation", prompt: "It’s been such a busy morning today, how are you holding up"),
        Scenario(id: "event", title: "Checking on One’s Day", prompt: "How’s your day going so far?"),
        Scenario(id: "class", title: "Personal Preference", prompt: "What do you usually like doing after work"),
        Scenario(id: "coffee", title: "Current Situation", prompt: "That meeting went by faster than I expected, what did you think of it?")
    ]
}
