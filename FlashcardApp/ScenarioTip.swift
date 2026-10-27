import Foundation

struct ScenarioTip: Identifiable {
    let id: String
    let title: String
    let detail: String
}

// نصائح كل تصنيف؛ عدّلي النصوص هنا لتتحدث صفحة Tips الخاصة به.
extension ScenarioCategory {
    var tips: [ScenarioTip] {
        switch self {
        case .icebreakers:
            return [
                ScenarioTip(id: "icebreakers-1", title: "Keep it low-pressure", detail: "Avoid overly personal or sensitive questions."),
                ScenarioTip(id: "icebreakers-2", title: "Make it relevant to the moment", detail: "Use the shared situation or context around you."),
                ScenarioTip(id: "icebreakers-3", title: "Ask open enough questions", detail: "Give the other person room to say more than yes/no."),
                ScenarioTip(id: "icebreakers-4", title: "Show you’re listening", detail: "Nod, maintain appropriate eye contact, and react naturally."),
                ScenarioTip(id: "icebreakers-5", title: "Use their answer to continue", detail: "Ask a small follow-up instead of immediately switching topics."),
                ScenarioTip(id: "icebreakers-6", title: "Don’t force it", detail: "If their response is short or they seem busy, let the conversation end naturally."),
                ScenarioTip(id: "icebreakers-7", title: "Avoid rapid-fire questions", detail: "Share a little about yourself too, so it feels like a conversation, not an interview.")
            ]
        case .turnTaking:
            return [
                ScenarioTip(id: "turnTaking-1", title: "Let the other person finish before taking your turn.", detail: ""),
                ScenarioTip(id: "turnTaking-2", title: "Use small listener cues", detail: "Use nodding, “mhm,” or “I see” to show you’re following without interrupting."),
                ScenarioTip(id: "turnTaking-3", title: "Respond soon after they finish", detail: "So the conversation keeps flowing."),
                ScenarioTip(id: "turnTaking-4", title: "If you both speak at once, yield naturally", detail: "With something like “go ahead.”"),
                ScenarioTip(id: "turnTaking-5", title: "Don’t dominate the conversation", detail: "Keep the exchange balanced.")
            ]
        case .awkwardSilence:
            return [
                ScenarioTip(id: "awkwardSilence-1", title: "Don’t panic at every pause", detail: "Some silence is normal."),
                ScenarioTip(id: "awkwardSilence-2", title: "Use something already said to restart the conversation.", detail: ""),
                ScenarioTip(id: "awkwardSilence-3", title: "Ask for clarification if the pause comes from confusion.", detail: ""),
                ScenarioTip(id: "awkwardSilence-4", title: "Change topics naturally when the current one has ended.", detail: ""),
                ScenarioTip(id: "awkwardSilence-5", title: "Give the other person time if they seem to still be thinking.", detail: ""),
                ScenarioTip(id: "awkwardSilence-6", title: "Avoid forcing random questions just to fill silence.", detail: "")
            ]
        case .microValidation:
            return [
                ScenarioTip(id: "microValidation-1", title: "Show that you heard them", detail: ""),
                ScenarioTip(id: "microValidation-2", title: "Acknowledge feelings without exaggerating", detail: ""),
                ScenarioTip(id: "microValidation-3", title: "Ask follow-up questions naturally", detail: ""),
                ScenarioTip(id: "microValidation-4", title: "Don’t immediately shift the conversation back to yourself", detail: ""),
                ScenarioTip(id: "microValidation-5", title: "You can validate someone’s perspective without agreeing with it", detail: ""),
                ScenarioTip(id: "microValidation-6", title: "Keep responses short and genuine", detail: "")
            ]
        }
    }
}
