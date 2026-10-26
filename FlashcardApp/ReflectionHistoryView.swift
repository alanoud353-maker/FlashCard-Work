import SwiftUI

// The category project's Reflection screen displays entries saved by ReflectionView.
struct ReflectionHistoryView: View {
    let onBack: () -> Void
    @State private var entries: [ReflectionEntry] = []

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 20) {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.title3.weight(.semibold))
                        .frame(width: 44, height: 44)
                }
                .accessibilityLabel("Back")

                Text("Reflection")
                    .font(.title.weight(.bold))
                Spacer()
            }
            .foregroundStyle(Color(red: 0.15, green: 0.25, blue: 0.15))
            .padding(.horizontal, 24)
            .padding(.top, 10)

            if entries.isEmpty {
                ContentUnavailableView("No reflections yet", systemImage: "square.and.pencil",
                                       description: Text("Your saved reflections will appear here."))
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(entries) { entry in
                            ReflectionHistoryCard(entry: entry)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .task {
            entries = ReflectionStorage().load().reversed()
        }
    }
}

private struct ReflectionHistoryCard: View {
    let entry: ReflectionEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(entry.scenarioTitle)
                .font(.headline)
            Text(entry.feeling)
                .font(.subheadline)
            Text(entry.reflectionText)
                .font(.body)
        }
        .foregroundStyle(Color("InkColor"))
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color("Cream"), in: RoundedRectangle(cornerRadius: 20))
    }
}
