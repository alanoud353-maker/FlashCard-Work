import Foundation

// الردود المقترحة مرتبطة بمعرّفات السيناريوهات الحالية لحفظ بياناتك كما هي.
extension Scenario {
    var responses: [String] {
        switch id {
        case "meeting":
            return [
                "There’s a really good Italian place nearby. Their pasta is great. It’s called ____",
                "I usually go for sushi, so I know a few good spots if you like that. They are ______",
                "I tried a new place last weekend actually. It was really good. It’s called _____"
            ]
        case "work":
            return [
                "Not too bad, but I definitely need a break soon. How are you doing?",
                "It’s been hectic, but I think the worst of it is over. What about you?"
            ]
        case "event":
            return [
                "Pretty good actually, it’s been calmer than I expected. How’s your day going?",
                "A little stressful, but nothing too bad. How’s yours?",
                "Good! I finally finished something I’d been working on for a while. What about you?"
            ]
        case "class":
            return [
                "Usually I just go home and relax, maybe watch something. How about you?",
                "I like going to the gym after work when I have the energy. What do you like doing after work?",
                "I usually meet friends or grab coffee somewhere. What about you?"
            ]
        case "coffee":
            return [
                "Same, I thought it would take much longer. It was actually pretty straightforward.",
                "I liked it, especially the part about the new project.",
                "It was good, but I think there were still a few things that weren’t totally clear."
            ]
        case "turn-taking-1":
            return [
                "Stay quiet for a moment",
                "Nod or use a small cue like “mhm”",
                "Let them finish before responding"
            ]
        case "turn-taking-2":
            return [
                "That sounds frustrating. What happened after that?",
                "I get why that would be stressful.",
                "Did you manage to sort it out?"
            ]
        case "turn-taking-3":
            return [
                "What do you think you’ll do next?",
                "That actually reminds me of something similar.",
                "How did you feel about that?"
            ]
        case "turn-taking-4":
            return [
                "Nod naturally",
                "Use brief responses like “yeah,” “right,” or “I see”",
                "Let them keep talking instead of immediately shifting to your own story"
            ]
        case "turn-taking-5":
            return [
                "Sorry, go ahead.",
                "You first.",
                "Pause and gesture for them to continue"
            ]
        case "awkward-silence-1":
            return [
                "That actually reminds me of something similar that happened to me.",
                "What you said just reminded me of another situation.",
                "That made me think of something related."
            ]
        case "awkward-silence-2":
            return [
                "What do you mean by that?",
                "Can you tell me a bit more?",
                "How did that happen?"
            ]
        case "awkward-silence-3":
            return [
                "You mentioned earlier that you were working on something new — how’s that going?",
                "Going back to what you said about your weekend, what happened after that?",
                "You said you’d been really busy lately — is it still like that?"
            ]
        case "awkward-silence-4":
            return [
                "By the way, how’s your week been so far?",
                "Speaking of work, are you busy with anything interesting right now?",
                "That reminds me — did you end up going to that event?"
            ]
        case "awkward-silence-5":
            return [
                "Don’t rush to fill the silence immediately.",
                "Give them a moment to finish their thought.",
                "Use a small cue like nodding or “mhm” to show you’re still engaged."
            ]
        case "micro-validation-1":
            return [
                "So it sounds like the deadline changed at the last minute?",
                "You mean you had to redo most of it?",
                "So the main issue was that you weren’t given enough time?"
            ]
        case "micro-validation-2":
            return [
                "That sounds really stressful.",
                "I can see why that would be frustrating.",
                "That sounds like a lot to deal with."
            ]
        case "micro-validation-3":
            return [
                "What happened after that?",
                "How did you handle it?",
                "What do you think you’ll do next?"
            ]
        case "micro-validation-4":
            return [
                "I can understand why you see it that way.",
                "That makes sense from your perspective.",
                "I get where you’re coming from."
            ]
        case "micro-validation-5":
            return [
                "Just to make sure I understood, you’re saying…?",
                "So if I got that right, the main issue is…?",
                "Do you mean that…?"
            ]
        default: return []
        }
    }
}
