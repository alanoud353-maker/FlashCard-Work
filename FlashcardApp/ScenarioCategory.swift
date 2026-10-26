import Foundation

// عدّلي title و prompt لكل سيناريو هنا. اتركي id ثابتًا وغير مكرر.
// سيناريوهات Icebreakers الحالية محفوظة، وباقي القيم مؤقتة لتعبئتها.
enum ScenarioCategory: String, CaseIterable, Identifiable {
    case icebreakers
    case turnTaking
    case awkwardSilence
    case microValidation

    var id: String { rawValue }

    var title: String {
        switch self {
        case .icebreakers: return "Icebreakers"
        case .turnTaking: return "Conversational Turn-Taking"
        case .awkwardSilence: return "Overcoming the Awkward Silence"
        case .microValidation: return "The Micro-Validation"
        }
    }

    var subtitle: String { "Start Conversations with Confidence." }

    var scenarios: [Scenario] {
        switch self {
        case .icebreakers: return Self.icebreakersScenarios
        case .turnTaking: return Self.turnTakingScenarios
        case .awkwardSilence: return Self.awkwardSilenceScenarios
        case .microValidation: return Self.microValidationScenarios
        }
    }

    // MARK: - Icebreakers — ٥ سيناريوهات
    private static let icebreakersScenarios: [Scenario] = [
        Scenario(id: "meeting", title: "Recommendation", prompt: "What’s a good restaurant you know? I’ve been wanting to try a new spot."),
        Scenario(id: "work", title: "Shared Situation", prompt: "It’s been such a busy morning today, how are you holding up"),
        Scenario(id: "event", title: "Checking on One’s Day", prompt: "How’s your day going so far?"),
        Scenario(id: "class", title: "Personal Preference", prompt: "What do you usually like doing after work"),
        Scenario(id: "coffee", title: "Current Situation", prompt: "That meeting went by faster than I expected, what did you think of it?")
    ]

    // MARK: - Conversational Turn-Taking — ٥ سيناريوهات
    private static let turnTakingScenarios: [Scenario] = [
        Scenario(
            id: "turn-taking-1",
            title: "Wait for the Turn", // اكتبي اسم السيناريو هنا
            prompt: "Your coworker is explaining something and pauses briefly, but they haven’t finished their thought yet. What do you do?" // اكتبي نص السيناريو هنا
        ),
        Scenario(
            id: "turn-taking-2",
            title: "Pick Up the Turn", // اكتبي اسم السيناريو هنا
            prompt: "Your coworker finishes telling you about a problem they had this morning.How do you respond?" // اكتبي نص السيناريو هنا
        ),
        Scenario(
            id: "turn-taking-3",
            title: "Avoid Long Gaps", // اكتبي اسم السيناريو هنا
            prompt: "Your coworker finishes speaking and the conversation goes quiet. What could you say next?" // اكتبي نص السيناريو هنا
        ),
        Scenario(
            id: "turn-taking-4",
            title: "Show You’re Following", // اكتبي اسم السيناريو هنا
            prompt: "our coworker is telling you about a stressful deadline. How can you show you’re listening without taking over the conversation?" // اكتبي نص السيناريو هنا
        ),
        Scenario(
            id: "turn-taking-5",
            title: "Recover from Overlap", // اكتبي اسم السيناريو هنا
            prompt: "You and your coworker start speaking at the same time. What do youdo?" // اكتبي نص السيناريو هنا
        )
    ]

    // MARK: - Overcoming the Awkward Silence — ٥ سيناريوهات
    private static let awkwardSilenceScenarios: [Scenario] = [
        Scenario(
            id: "awkward-silence-1",
            title: " This Reminds Me", // اكتبي اسم السيناريو هنا
            prompt: "The conversation goes quiet after your coworker finishes a story" // اكتبي نص السيناريو هنا
        ),
        Scenario(
            id: "awkward-silence-2",
            title: "Ask for Clarification", // اكتبي اسم السيناريو هنا
            prompt: "The conversation pauses because you’re not fully sure what your coworker meant." // اكتبي نص السيناريو هنا
        ),
        Scenario(
            id: "awkward-silence-3",
            title: "Go Back to Something They Said", // اكتبي اسم السيناريو هنا
            prompt: "The conversation goes quiet, but they mentioned something interesting earlier." // اكتبي نص السيناريو هنا
        ),
        Scenario(
            id: "awkward-silence-4",
            title: "Shift the Topic Naturally", // اكتبي اسم السيناريو هنا
            prompt: "The current topic has clearly run out." // اكتبي نص السيناريو هنا
        ),
        Scenario(
            id: "awkward-silence-5",
            title: "Give the Silence a Moment", // اكتبي اسم السيناريو هنا
            prompt: "There’s a short pause, but the other person looks like they’re still thinking." // اكتبي نص السيناريو هنا
        )
    ]

    // MARK: - The Micro-Validation — ٥ سيناريوهات
    private static let microValidationScenarios: [Scenario] = [
        Scenario(
            id: "micro-validation-1",
            title: "Paraphrase", // اكتبي اسم السيناريو هنا
            prompt: "Your coworker explains something that has been frustrating them" // اكتبي نص السيناريو هنا
        ),
        Scenario(
            id: "micro-validation-2",
            title: "Acknowledge the Feeling", // اكتبي اسم السيناريو هنا
            prompt: "Your coworker tells you they’re stressed about a project." // اكتبي نص السيناريو هنا
        ),
        Scenario(
            id: "micro-validation-3",
            title: "Ask a Follow-Up", // اكتبي اسم السيناريو هنا
            prompt: "Your coworker tells you something important that happened at work." // اكتبي نص السيناريو هنا
        ),
        Scenario(
            id: "micro-validation-4",
            title: "Show Understanding Without Agreeing", // اكتبي اسم السيناريو هنا
            prompt: "Your coworker shares an opinion you don’t necessarily agree with." // اكتبي نص السيناريو هنا
        ),
        Scenario(
            id: "micro-validation-5",
            title: "Confirm You Understood", // اكتبي اسم السيناريو هنا
            prompt: "Your coworker gives you a complicated explanation." // اكتبي نص السيناريو هنا
        )
    ]
}
