
import SwiftUI

struct ReflectionView: View {
    @Environment(\.dismiss) private var dismiss

    let scenario: Scenario
    private let isReadOnly: Bool

    init(scenario: Scenario) {
        self.scenario = scenario
        self.isReadOnly = false
    }

    init(entry: ReflectionEntry) {
        self.scenario = Scenario(id: entry.scenarioID, title: entry.scenarioTitle, prompt: "")
        self.isReadOnly = true
        _selectedFeeling = State(initialValue: entry.feeling)
        _reflectionText = State(initialValue: entry.reflectionText)
    }

    private let storage = ReflectionStorage()

    @State private var selectedFeeling: String? = nil
    @State private var reflectionText: String = ""
    @State private var showDiscarAlrt = false
    @State private var showSavedAlert = false

    private let feelings = ["Uneasy", "Neutral", "Good", "Great"]

    private let cream = Color("Cream")
    private let primaryGreen = Color("PrimaryGreen")
    private let oliveGreen = Color("OliveGreen")
    private let gold = Color("Gold")
    private let brown = Color("Brown")

    var body: some View {
        ZStack(alignment: .bottom) {

            cream
                .ignoresSafeArea()

            UnevenRoundedRectangle(
                topLeadingRadius: 32,
                topTrailingRadius: 32
            )
            .fill(.white)
            .overlay {
                VStack(alignment: .leading, spacing: 16) {

                    // Sheet handle
                    Capsule()
                        .fill(gold)
                        .frame(width: 58, height: 6)
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 4)

                    // Dynamic scenario title
                    HStack {
                        Text(scenario.title)
                            .foregroundStyle(primaryGreen)
                            .font(.title)
                            .bold()

                        Spacer()

                        Button {
                            if isReadOnly {
                                dismiss()
                            } else {
                                showDiscarAlrt = true
                            }
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundStyle(.white)
                                .frame(width: 36, height: 36)
                                .background(
                                    oliveGreen,
                                    in: Circle()
                                )
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Close")
                    }

                    // Feeling section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Your reflection")
                            .font(.subheadline)
                            .foregroundStyle(brown)

                        RoundedRectangle(cornerRadius: 20)
                            .fill(cream)
                            .frame(height: 160)
                            .overlay {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("How are you feeling?")
                                        .font(.title3)
                                        .foregroundStyle(primaryGreen)

                                    HStack(spacing: 8) {
                                        ForEach(feelings, id: \.self) { feeling in
                                            Button {
                                                selectedFeeling = feeling
                                            } label: {
                                                VStack(spacing: 6) {
                                                    FaceView(
                                                        feeling: feeling
                                                    )

                                                    Text(feeling)
                                                        .font(.caption)
                                                        .foregroundStyle(
                                                            selectedFeeling == feeling
                                                            ? primaryGreen
                                                            : .gray
                                                        )
                                                        .lineLimit(1)
                                                        .minimumScaleFactor(0.75)
                                                }
                                                .frame(maxWidth: .infinity)
                                                .frame(height: 100)
                                                .background(
                                                    selectedFeeling == feeling
                                                    ? gold
                                                    : .white,
                                                    in: RoundedRectangle(
                                                        cornerRadius: 14
                                                    )
                                                )
                                                .contentShape(
                                                    RoundedRectangle(
                                                        cornerRadius: 14
                                                    )
                                                )
                                            }
                                            .buttonStyle(.plain)
                                            .disabled(isReadOnly)
                                        }
                                    }
                                }
                                .padding(12)
                            }
                    }

                    // Reflection text section
                    RoundedRectangle(cornerRadius: 20)
                        .fill(cream)
                        .frame(height: 190)
                        .overlay {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("What happened?")
                                    .font(.title3)
                                    .foregroundStyle(primaryGreen)

                                
                                ZStack(alignment: .topLeading) {
                                    if isReadOnly {
                                        ScrollView {
                                            Text(reflectionText)
                                                .font(.body)
                                                .foregroundStyle(brown)
                                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                                .textSelection(.enabled)
                                                .padding(8)
                                        }
                                        .frame(height: 120)
                                        .background(.white, in: RoundedRectangle(cornerRadius: 16))
                                    } else {
                                        TextEditor(text: $reflectionText)
                                            .font(.body)
                                            .foregroundStyle(brown)
                                            .scrollContentBackground(.hidden)
                                            .padding(8)
                                            .frame(height: 120)
                                            .background(
                                                .white,
                                                in: RoundedRectangle(cornerRadius: 16)
                                            )
                                    }

                                    if !isReadOnly && reflectionText.isEmpty {
                                        Text("Take a moment to reflect on your day")
                                            .font(.body)
                                            .foregroundStyle(.darkGray.opacity(0.5))
                                            .padding(.leading, 13)
                                            .padding(.top, 16)
                                            .allowsHitTesting(false)
                                            
                                    }
                                }

                            }
                            .padding(16)
                        }

                    Spacer(minLength: 0)

                    // Done button
                    Button {
                        if isReadOnly {
                            dismiss()
                            return
                        }
                        guard let feeling = selectedFeeling else {
                            return
                        }

                        let entry = ReflectionEntry(
                            scenarioID: scenario.id,
                            scenarioTitle: scenario.title,
                            feeling: feeling,
                            reflectionText: reflectionText
                        )

                        storage.save(entry)

                        showSavedAlert = true
                    } label: {
                        Capsule()
                            .fill(oliveGreen)
                            .frame(width: 200, height: 56)
                            .overlay {
                                Text("Done")
                                    .font(.title3)
                                    .foregroundStyle(.white)
                            }
                    }
                    .buttonStyle(.plain)
                    .shadow(
                        color: .black.opacity(0.15),
                        radius: 6,
                        x: 0,
                        y: 4
                    )
                    .frame(maxWidth: .infinity)
                    .disabled(
                        !isReadOnly && (selectedFeeling == nil ||
                        reflectionText.trimmingCharacters(
                            in: .whitespacesAndNewlines
                        ).isEmpty)
                    )
                    .opacity(
                        !isReadOnly && (selectedFeeling == nil ||
                        reflectionText.trimmingCharacters(
                            in: .whitespacesAndNewlines
                        ).isEmpty) ? 0.6 : 1
                    )
                }
                .padding(.horizontal, 20)
                .padding(.top, 14)
                .padding(.bottom, 24)
            }
            .frame(height: 640)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea(edges: .bottom)
        }

        // Discard alert
        .alert("Discard reflection?", isPresented: $showDiscarAlrt) {
            Button("Keep Editing", role: .cancel) {}

            Button("Discard", role: .destructive) {
                reflectionText = ""
                selectedFeeling = nil
                dismiss()
            }
        } message: {
            Text("Are you sure you want to discard your reflection?")
        }

        // Save confirmation alert
        .alert("Reflection Saved!", isPresented: $showSavedAlert) {
            Button("OK", role: .cancel) { dismiss() }
        } message: {
            Text("Reflection has been saved in reflection dashboard")
        }
    }


}

struct FaceView: View {
    let smile: CGFloat

    init(feeling: String) {
        switch feeling {
        case "Uneasy": smile = -1
        case "Neutral": smile = 0
        case "Good": smile = 0.6
        default: smile = 1
        }
    }

    private let green = Color("PrimaryGreen")

    var body: some View {
        ZStack {
            Circle()
                .stroke(green, lineWidth: 3)

            HStack(spacing: 10) {
                Circle()
                    .fill(green)
                    .frame(width: 5, height: 5)

                Circle()
                    .fill(green)
                    .frame(width: 5, height: 5)
            }
            .offset(y: -6)

            Path { path in
                let y: CGFloat = smile < 0 ? 31 : 27

                path.move(to: CGPoint(x: 14, y: y))

                path.addQuadCurve(
                    to: CGPoint(x: 30, y: y),
                    control: CGPoint(
                        x: 22,
                        y: y + smile * 8
                    )
                )
            }
            .stroke(
                green,
                style: StrokeStyle(
                    lineWidth: 3,
                    lineCap: .round
                )
            )
        }
        .frame(width: 44, height: 44)
    }
}

#Preview {
    ReflectionView(
        scenario: Scenario(
            id: "meeting",
            title: "Recommendation",
            prompt: "What’s a good restaurant you know?"
        )
    )
}
