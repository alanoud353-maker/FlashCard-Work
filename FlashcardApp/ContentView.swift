import SwiftUI

@MainActor
struct ContentView: View {
    @State private var viewModel: ScenariosViewModel
    @State private var showsTips = false

    let category: ScenarioCategory
    var onBack: (() -> Void)?
    var onStartPractice: ((Scenario) -> Void)?
    static let practiceYellow = Color(red: 0.98, green: 0.88, blue: 0.59, opacity: 0.85)
    init(
        category: ScenarioCategory = .icebreakers,
        viewModel: ScenariosViewModel? = nil,
        onBack: (() -> Void)? = nil,
        onStartPractice: ((Scenario) -> Void)? = nil
    ) {
        self.category = category
        _viewModel = State(initialValue: viewModel ?? ScenariosViewModel(scenarios: category.scenarios))
        self.onBack = onBack
        self.onStartPractice = onStartPractice
    }

    var body: some View {
        @Bindable var viewModel = viewModel

        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    ScenarioHeader(title: category.title, onBack: onBack, onTips: { showsTips = true })
                        .padding(.horizontal, 24)
                        .padding(.top, 16)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Scenario")
                            .font(.title.weight(.semibold))
                        Text("Choose a Scenario!")
                            .font(.title3)
                            .foregroundStyle(Color("SubtitleColor"))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 40)
                    .padding(.top,70)
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
        .foregroundStyle(Color("InkColor"))
        .background(ScenarioBackground())
     
        .allowsHitTesting(!showsTips)
        .accessibilityHidden(showsTips)
        .overlay {
            if showsTips {
                GeometryReader { geometry in
                    ZStack {
                        Color.black.opacity(0.35)
                            .ignoresSafeArea()
                            .onTapGesture { showsTips = false }
                            .accessibilityHidden(true)

                        ScenarioTipsView(category: category, onClose: { showsTips = false })
                            .frame(width: max(1, min(geometry.size.width - 40, 440)),
                                   height: min(geometry.size.height * 0.75, 560))
                            .clipShape(RoundedRectangle(cornerRadius: 28))
                            .shadow(color: .black.opacity(0.2), radius: 24, y: 12)
                            .accessibilityAddTraits(.isModal)
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
        }
        .sheet(item: $viewModel.practiceScenario) { scenario in
            ScenarioPracticeView(scenario: scenario)
        }
    }
}

private struct ScenarioHeader: View {
    let title: String
    let onBack: (() -> Void)?
    let onTips: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            Button(action: { onBack?() }) {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .frame(minWidth: 32, minHeight: 44)
                    .foregroundStyle(.black)
            }
            .buttonStyle(.plain)
            .disabled(onBack == nil)
            .accessibilityLabel("Back")
            Text(title)
                .font(.title2.weight(.bold))
            
            Spacer(minLength: 8)
            Button(action: onTips) {
                Label("Tips", systemImage: "lightbulb")
                    .font(.headline)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 5)
                    .background(Color("TipsBackground"), in: Capsule())
                    .overlay(Capsule().stroke(Color("CardColor"), lineWidth: 1))
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
                    .multilineTextAlignment(.center)
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
                    .foregroundStyle(Color("PracticeButtonText"))
                    .padding(.horizontal, 18)
                    .padding(.vertical, 14)
                    .background(Color("PracticeButtonColor"), in: Capsule())
                    .shadow(color: Color("PracticeButtonShadow"), radius: 4, y: 3)
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
        .background(Color(red: 0.98, green: 0.88, blue: 0.59, opacity: 0.6), in: RoundedRectangle(cornerRadius: 36))
        .shadow(color: Color("CardShadow"), radius: 4, y: 4)
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
                                  ? Color("PageIndicatorSelected") : Color("PageIndicatorUnselected"))
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

struct ScenarioBackground: View {
    var body: some View {
        GeometryReader { geometry in
            Image("SplashBackgroundImage")
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

#Preview {
    ContentView()
}
