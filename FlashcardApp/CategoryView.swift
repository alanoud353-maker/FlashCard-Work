import SwiftUI

struct CategoryView: View {
    @State private var currentTab = "Category"
    @State private var showsScenarios = false
    @State private var showsUnavailableCategory = false

    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundImage()

                VStack(spacing: 0) {
                    if currentTab == "Reflection" {
                        ReflectionHistoryView {
                            currentTab = "Category"
                        }
                    } else {
                        ScrollView {
                            VStack(spacing: 8) {
                                Text("Category")
                                    .font(.system(size: 38, weight: .bold))
                                    .foregroundStyle(Color(red: 0.15, green: 0.25, blue: 0.15))
                                    .padding(40)

                                CategoryButtonView(title: "Icebreakers", subtitle: "Start Conversations with Confidence.") {
                                    showsScenarios = true
                                }
                                CategoryButtonView(title: "Conversational Turn-Taking", subtitle: "Start Conversation with confidence.") {
                                    showsUnavailableCategory = true
                                }
                                CategoryButtonView(title: "Overcoming the Awkward Silence", subtitle: "Start Conversation with confidence.") {
                                    showsUnavailableCategory = true
                                }
                                CategoryButtonView(title: "The Micro-Validation", subtitle: "Start Conversation with confidence.") {
                                    showsUnavailableCategory = true
                                }
                            }
                            .padding(.bottom, 24)
                        }
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                BottomBarView(
                    onCategoryTapped: { currentTab = "Category" },
                    onReflectionTapped: { currentTab = "Reflection" },
                    selectedTab: $currentTab
                )
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
            }
            .navigationDestination(isPresented: $showsScenarios) {
                ContentView(onBack: { showsScenarios = false })
                    .navigationBarBackButtonHidden(true)
            }
            .alert("Coming soon", isPresented: $showsUnavailableCategory) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Scenarios for this category are not available yet.")
            }
        }
    }
}

#Preview {
    CategoryView()
}

