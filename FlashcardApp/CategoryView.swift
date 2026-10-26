import SwiftUI

struct CategoryView: View {
    @State private var currentTab = "Category"
    @State private var selectedCategory: ScenarioCategory?

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

                                ForEach(ScenarioCategory.allCases) { category in
                                    CategoryButtonView(title: category.title, subtitle: category.subtitle) {
                                        selectedCategory = category
                                    }
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
            .navigationDestination(item: $selectedCategory) { category in
                ContentView(
                    category: category,
                    onBack: { selectedCategory = nil }
                )
                .id(category.id)
                .navigationBarBackButtonHidden(true)
            }
        }
    }
}

#Preview {
    CategoryView()
}

