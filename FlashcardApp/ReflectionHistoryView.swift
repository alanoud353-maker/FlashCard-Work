import SwiftUI

// The category project's Reflection screen displays entries saved by ReflectionView.
struct ReflectionHistoryView: View {
    let onBack: () -> Void
    @State private var entries: [ReflectionEntry] = []
    @State private var selectedEntry: ReflectionEntry?
    @State private var showsDeleteError = false
    @State private var entryToDelete: ReflectionEntry?
    @State private var showsDeleteConfirmation = false

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
                List {
                    ForEach(entries) { entry in
                        Button {
                            selectedEntry = entry
                        } label: {
                            ReflectionHistoryCard(entry: entry)
                        }
                        .buttonStyle(.plain)
                        .accessibilityHint("Opens your saved reflection")
                        .listRowInsets(EdgeInsets(top: 8, leading: 24, bottom: 8, trailing: 24))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button {
                                entryToDelete = entry
                                showsDeleteConfirmation = true
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
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
        .alert("Delete reflection?", isPresented: $showsDeleteConfirmation, presenting: entryToDelete) { entry in
            Button("Cancel", role: .cancel) {
                entryToDelete = nil
            }
            Button("Delete", role: .destructive) {
                delete(entry)
                entryToDelete = nil
            }
        } message: { _ in
            Text("Are you sure you want to delete this reflection? This cannot be undone.")
        }
        .alert("Couldn’t delete reflection", isPresented: $showsDeleteError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Please try again.")
        }
    }

    private func delete(_ entry: ReflectionEntry) {
        do {
            try ReflectionStorage().delete(id: entry.id)
            withAnimation {
                entries.removeAll { $0.id == entry.id }
            }
        } catch {
            showsDeleteError = true
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
                    .foregroundStyle(Color(red: 0.216, green: 0.251, blue: 0.271))
                    .lineLimit(2)
                    .truncationMode(.tail)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .reflectionTextDirection(for: entry.reflectionText)
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
