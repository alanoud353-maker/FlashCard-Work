
extension Scenario {
    static let all: [Scenario] = [
 
        // MARK: - Ice Breakers
 
        Scenario(
            category: "Ice Breakers",
            title: "New Spot",
            prompt: "Do you know any good places to eat around here?",
            responses: [
                "There’s a really good Italian place nearby. Their pasta is great. It’s called ____",
                "I usually go for sushi, so I know a few good spots if you like that. They are ______",
                "I tried a new place last weekend actually. It was really good. It’s called _____"
            ]
        ),
        Scenario(
            category: "Ice Breakers",
            title: "Shared Situation",
            prompt: "It’s been such a busy morning today, how are you holding up?",
            responses: [
                "Not too bad, but I definitely need a break soon. How are you doing?",
                "It’s been hectic, but I think the worst of it is over. What about you?"
            ]
        ),
        Scenario(
            category: "Ice Breakers",
            title: "Checking on One’s Day",
            prompt: "How’s your day going so far?",
            responses: [
                "Pretty good actually, it’s been calmer than I expected. How’s your day going?",
                "A little stressful, but nothing too bad. How’s yours?",
                "Good! I finally finished something I’d been working on for a while. What about you?"
            ]
        ),
        Scenario(
            category: "Ice Breakers",
            title: "Personal Preference",
            prompt: "What do you usually like doing after work?",
            responses: [
                "Usually I just go home and relax, maybe watch something. How about you?",
                "I like going to the gym after work when I have the energy. What do you like doing after work?",
                "I usually meet friends or grab coffee somewhere. What about you?"
            ]
        ),
        Scenario(
            category: "Ice Breakers",
            title: "Current Situation",
            prompt: "That meeting went by faster than I expected, what did you think of it?",
            responses: [
                "Same, I thought it would take much longer. It was actually pretty straightforward.",
                "I liked it, especially the part about the new project.",
                "It was good, but I think there were still a few things that weren’t totally clear."
            ]
        ),
 
        // MARK: - Turn Taking
 
        Scenario(
            category: "Turn Taking",
            title: "Wait for the Turn",
            prompt: "Your coworker is explaining something and pauses briefly, but they haven’t finished their thought yet. What do you do?",
            responses: [
                "Stay quiet for a moment",
                "Nod or use a small cue like “mhm”",
                "Let them finish before responding"
            ]
        ),
        Scenario(
            category: "Turn Taking",
            title: "Pick Up the Turn",
            prompt: "Your coworker finishes telling you about a problem they had this morning. How do you respond?",
            responses: [
                "That sounds frustrating. What happened after that?",
                "I get why that would be stressful.",
                "Did you manage to sort it out?"
            ]
        ),
        Scenario(
            category: "Turn Taking",
            title: "Avoid Long Gaps",
            prompt: "Your coworker finishes speaking and the conversation goes quiet. What could you say next?",
            responses: [
                "What do you think you’ll do next?",
                "That actually reminds me of something similar.",
                "How did you feel about that?"
            ]
        ),
        Scenario(
            category: "Turn Taking",
            title: "Show You’re Following",
            prompt: "Your coworker is telling you about a stressful deadline. How can you show you’re listening without taking over the conversation?",
            responses: [
                "Nod naturally",
                "Use brief responses like “yeah,” “right,” or “I see”",
                "Let them keep talking instead of immediately shifting to your own story"
            ]
        ),
        Scenario(
            category: "Turn Taking",
            title: "Recover from Overlap",
            prompt: "You and your coworker start speaking at the same time. What do you do?",
            responses: [
                "Sorry, go ahead.",
                "You first.",
                "Pause and gesture for them to continue"
            ]
        ),
 
        // MARK: - Overcoming Awkward Silence
 
        Scenario(
            category: "Overcoming Awkward Silence",
            title: "This Reminds Me",
            prompt: "The conversation goes quiet after your coworker finishes a story.",
            responses: [
                "That actually reminds me of something similar that happened to me.",
                "What you said just reminded me of another situation.",
                "That made me think of something related."
            ]
        ),
        Scenario(
            category: "Overcoming Awkward Silence",
            title: "Ask for Clarification",
            prompt: "The conversation pauses because you’re not fully sure what your coworker meant.",
            responses: [
                "What do you mean by that?",
                "Can you tell me a bit more?",
                "How did that happen?"
            ]
        ),
        Scenario(
            category: "Overcoming Awkward Silence",
            title: "Go Back to Something They Said",
            prompt: "The conversation goes quiet, but they mentioned something interesting earlier.",
            responses: [
                "You mentioned earlier that you were working on something new — how’s that going?",
                "Going back to what you said about your weekend, what happened after that?",
                "You said you’d been really busy lately — is it still like that?"
            ]
        ),
        Scenario(
            category: "Overcoming Awkward Silence",
            title: "Shift the Topic Naturally",
            prompt: "The current topic has clearly run out.",
            responses: [
                "By the way, how’s your week been so far?",
                "Speaking of work, are you busy with anything interesting right now?",
                "That reminds me — did you end up going to that event?"
            ]
        ),
        Scenario(
            category: "Overcoming Awkward Silence",
            title: "Give the Silence a Moment",
            prompt: "There’s a short pause, but the other person looks like they’re still thinking.",
            responses: [
                "Don’t rush to fill the silence immediately.",
                "Give them a moment to finish their thought.",
                "Use a small cue like nodding or “mhm” to show you’re still engaged."
            ]
        ),
 
        // MARK: - MicroValidation
 
        Scenario(
            category: "MicroValidation",
            title: "Reflect Back What You Heard",
            prompt: "Your coworker explains something that has been frustrating them.",
            responses: [
                "So it sounds like the deadline changed at the last minute?",
                "You mean you had to redo most of it?",
                "So the main issue was that you weren’t given enough time?"
            ]
        ),
        Scenario(
            category: "MicroValidation",
            title: "Acknowledge the Feeling",
            prompt: "Your coworker tells you they’re stressed about a project.",
            responses: [
                "That sounds really stressful.",
                "I can see why that would be frustrating.",
                "That sounds like a lot to deal with."
            ]
        ),
        Scenario(
            category: "MicroValidation",
            title: "Ask a Follow-Up",
            prompt: "Your coworker tells you something important that happened at work.",
            responses: [
                "What happened after that?",
                "How did you handle it?",
                "What do you think you’ll do next?"
            ]
        ),
        Scenario(
            category: "MicroValidation",
            title: "Show Understanding Without Agreeing",
            prompt: "Your coworker shares an opinion you don’t necessarily agree with.",
            responses: [
                "I can understand why you see it that way.",
                "That makes sense from your perspective.",
                "I get where you’re coming from."
            ]
        ),
        Scenario(
            category: "MicroValidation",
            title: "Confirm You Understood",
            prompt: "Your coworker gives you a complicated explanation.",
            responses: [
                "Just to make sure I understood, you’re saying…?",
                "So if I got that right, the main issue is…?",
                "Do you mean that…?"
            ]
        )
    ]
}
 
