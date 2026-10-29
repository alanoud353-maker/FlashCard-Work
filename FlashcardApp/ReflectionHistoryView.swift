import SwiftUI

// The category project's Reflection screen displays entries saved by ReflectionView.
struct ReflectionHistoryView: View {
    let onBack: () -> Void
    @State private var entries: [ReflectionEntry] = []
    @State private var selectedEntry: ReflectionEntry?

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 20) {
              

                Text("Reflection")
                    .font(.system(size: 38, weight: .bold))
                    .foregroundStyle(Color(red: 0.15, green: 0.25, blue: 0.15))
                    .padding(40)
            }
            .foregroundStyle(Color(red: 0.15, green: 0.25, blue: 0.15))
            .padding(.horizontal, 24)
            //.padding(.top, 10)

            if entries.isEmpty {
                ContentUnavailableView("No reflections yet", systemImage: "square.and.pencil",
                                       description: Text("Your saved reflections will appear here."))
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(entries) { entry in
                            Button {
                                selectedEntry = entry
                            } label: {
                                ReflectionHistoryCard(entry: entry)
                            }
                            .buttonStyle(.plain)
                            .accessibilityHint("Opens your saved reflection")
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)
                    
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .sheet(item: $selectedEntry) { entry in
            ReflectionView(entry: entry)
                .presentationDetents([.height(640)])
                .presentationDragIndicator(.hidden)
                .presentationCornerRadius(32)
        }
        .task {
            entries = ReflectionStorage().load().reversed()
        }
    }
}

private struct ReflectionHistoryCard: View {
    let entry: ReflectionEntry

    var body: some View {
        HStack(spacing: 16) {
            FaceView(feeling: entry.feeling)
                .scaleEffect(1.15)
                .frame(width: 52, height: 52)
                .accessibilityLabel(Text(entry.feeling))

            VStack(alignment: .leading, spacing: 6) {
                Text(entry.scenarioTitle)
                    .font(.title2.weight(.bold))
                    .lineLimit(2)
                Text(entry.reflectionText)
                    .font(.body)
                Color(red: 0.216, green: 0.251, blue: 0.271)                    .truncationMode(.tail)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color(red: 0.15, green: 0.25, blue: 0.15))
                .accessibilityHidden(true)
        }
        .foregroundColor(Color(red: 0.15, green: 0.25, blue: 0.15))
        .frame(height: 40)
                .padding(.horizontal, 20)
                .padding(.vertical, 28)
                .frame(maxWidth: .infinity, alignment: .leading)
                //Card color
                .background(Color("Cream"), in: RoundedRectangle(cornerRadius: 28))
                .shadow(color: .black.opacity(0.16), radius: 8, y: 6)

                .contentShape(RoundedRectangle(cornerRadius: 28))
    }
}
