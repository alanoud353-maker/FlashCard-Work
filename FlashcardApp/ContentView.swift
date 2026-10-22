import SwiftUI

private enum ScenarioColors {
    static let background = Color(red: 1, green: 0.985, blue: 0.925)
    static let card = Color(red: 0.99, green: 0.885, blue: 0.61)
    static let ink = Color(red: 0.26, green: 0.33, blue: 0.23)
    static let green = Color(red: 0.41, green: 0.52, blue: 0.26)
}

@MainActor
struct ContentView: View {
    @State private var viewModel: ScenariosViewModel
    @State private var showsTips = false

    var onBack: (() -> Void)?
    var onStartPractice: ((Scenario) -> Void)?

    init(
        viewModel: ScenariosViewModel? = nil,
        onBack: (() -> Void)? = nil,
        onStartPractice: ((Scenario) -> Void)? = nil
    ) {
        _viewModel = State(initialValue: viewModel ?? ScenariosViewModel())
        self.onBack = onBack
        self.onStartPractice = onStartPractice
    }

    var body: some View {
        @Bindable var viewModel = viewModel

        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    ScenarioHeader(onBack: onBack, onTips: { showsTips = true })
                        .padding(.horizontal, 24)
                        .padding(.top, 16)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Scenario")
                            .font(.title3.weight(.semibold))
                        Text("Choose a Scenario!")
                            .font(.subheadline)
                            .foregroundStyle(.primary.opacity(0.75))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 40)
                    .padding(.top, max(40, geometry.size.height * 0.14))
                    .padding(.bottom, 4)

                    if viewModel.scenarios.isEmpty {
                        ContentUnavailableView("No scenarios yet", systemImage: "rectangle.on.rectangle",
                                               description: Text("Add a scenario to get started."))
                            .frame(minHeight: 300)
                    } else {
                        ScrollView(.horizontal) {
                            LazyHStack(spacing: 12) {
                                ForEach(viewModel.scenarios) { scenario in
                                    ScenarioCard(scenario: scenario) {
                                        if let onStartPractice {
                                            onStartPractice(scenario)
                                        } else {
                                            viewModel.startPractice(for: scenario)
                                        }
                                    }
                                    .frame(width: max(1, min(geometry.size.width - 60, 440)))
                                }
                            }
                            .scrollTargetLayout()
                            .padding(.vertical, 8)
                        }
                        .contentMargins(.horizontal, 30, for: .scrollContent)
                        .scrollIndicators(.hidden)
                        .scrollTargetBehavior(.viewAligned)
                        .scrollPosition(id: $viewModel.selectedID, anchor: .center)

                        ScenarioPagination(scenarios: viewModel.scenarios, selectedID: viewModel.selectedID, currentPage: viewModel.currentPage) { id in
                            withAnimation { viewModel.selectScenario(id: id) }
                        }
                        .padding(.top, max(32, geometry.size.height * 0.11))
                        .padding(.bottom, 40)
                    }
                }
                .frame(minHeight: geometry.size.height, alignment: .top)
            }
            .scrollIndicators(.hidden)
        }
        .foregroundStyle(ScenarioColors.ink)
        .background(ScenarioBackground())
        .sheet(isPresented: $showsTips) {
            NavigationStack {
                VStack(alignment: .leading, spacing: 24) {
                    Label("Start with a smile.", systemImage: "face.smiling")
                    Label("Ask an open-ended question.", systemImage: "bubble.left.and.bubble.right")
                    Label("Listen, then ask a follow-up.", systemImage: "ear")
                    Spacer()
                }
                .padding(28)
                .navigationTitle("Tips")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") { showsTips = false }
                    }
                }
            }
            .presentationDetents([.medium])
        }
        .sheet(item: $viewModel.practiceScenario) { scenario in
            ScenarioPractice(scenario: scenario)
        }
    }
}

private struct ScenarioHeader: View {
    let onBack: (() -> Void)?
    let onTips: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            Button(action: { onBack?() }) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .frame(minWidth: 32, minHeight: 44)
            }
            .buttonStyle(.plain)
            .disabled(onBack == nil)
            .accessibilityLabel("Back")
            Text("Ice Breakers")
                .font(.title2.weight(.bold))
            Spacer(minLength: 8)
            Button(action: onTips) {
                Label("Tips", systemImage: "lightbulb")
                    .font(.headline)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 5)
                    .background(ScenarioColors.background.opacity(0.7), in: Capsule())
                    .overlay(Capsule().stroke(ScenarioColors.card, lineWidth: 1))
            }
            .buttonStyle(.plain)
        }
    }
}

private struct ScenarioCard: View {
    let scenario: Scenario
    let onPractice: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isFlipped = false
    @State private var rotation = 0.0
    @State private var isFlipping = false
    @ScaledMetric(relativeTo: .largeTitle) private var cardHeight = 350

    var body: some View {
        VStack(spacing: 0) {
            Button(action: flip) {
                Text(isFlipped ? scenario.prompt : scenario.title)
                    .font(.largeTitle.weight(.bold))
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .padding(.horizontal, 40)
                    .padding(.top, 32)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityHint(isFlipped ? "Shows the scenario title" : "Flips the card to reveal a conversation starter")

            if isFlipped {
                Button("Start Practice", action: onPractice)
                    .font(.body)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 14)
                    .background(ScenarioColors.green, in: Capsule())
                    .shadow(color: .black.opacity(0.18), radius: 4, y: 3)
                    .padding(.bottom, 34)
            } else {
                Button(action: flip) {
                    Label("Tap card to flip", systemImage: "arrow.triangle.2.circlepath")
                        .font(.footnote.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                }
                .buttonStyle(.plain)
            }
        }
        .frame(height: cardHeight)
        .frame(maxWidth: .infinity)
        .background(ScenarioColors.card, in: RoundedRectangle(cornerRadius: 36))
        .shadow(color: .black.opacity(0.17), radius: 4, y: 4)
        .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0), perspective: 0.5)
        .disabled(isFlipping)
    }

    private func flip() {
        guard !isFlipping else { return }
        guard !reduceMotion else {
            isFlipped.toggle()
            return
        }
        isFlipping = true
        // Change faces edge-on so the text never appears mirrored.
        withAnimation(.easeIn(duration: 0.18), completionCriteria: .logicallyComplete) {
            rotation = 90
        } completion: {
            isFlipped.toggle()
            rotation = -90
            withAnimation(.easeOut(duration: 0.18), completionCriteria: .logicallyComplete) {
                rotation = 0
            } completion: {
                isFlipping = false
            }
        }
    }
}

private struct ScenarioPagination: View {
    let scenarios: [Scenario]
    let selectedID: Scenario.ID?
    let currentPage: Int
    let onSelect: (Scenario.ID) -> Void

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 7) {
                ForEach(scenarios) { scenario in
                    Button {
                        onSelect(scenario.id)
                    } label: {
                        Capsule()
                            .fill(scenario.id == selectedID
                                  ? Color.gray.opacity(0.55) : Color.gray.opacity(0.22))
                            .frame(maxWidth: 26)
                            .frame(height: 7)
                            .frame(height: 24)
                    }
                    .accessibilityLabel(Text(scenario.title))
                    .accessibilityAddTraits(scenario.id == selectedID ? .isSelected : [])
                }
            }
            .frame(maxWidth: 300)
            Text("\(currentPage) / \(scenarios.count)")
                .font(.headline)
        }
    }
}

private struct ScenarioBackground: View {
    var body: some View {
        GeometryReader { geometry in
            Image("Image")
                .resizable()
                .scaledToFill()
                .frame(width: geometry.size.width, height: geometry.size.height)
                .clipped()
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

private struct ScenarioPractice: View {
    let scenario: Scenario
    @Environment(\.dismiss) private var dismiss
    @State private var response = ""

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                Text(scenario.prompt)
                    .font(.title.weight(.bold))
                Text("Practice your response")
                    .font(.headline)
                TextEditor(text: $response)
                    .padding(12)
                    .scrollContentBackground(.hidden)
                    .background(.white.opacity(0.6), in: RoundedRectangle(cornerRadius: 20))
                    .accessibilityLabel("Your practice response")
            }
            .padding(24)
            .foregroundStyle(ScenarioColors.ink)
            .background(ScenarioBackground())
            .navigationTitle("Practice")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
