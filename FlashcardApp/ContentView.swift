import SwiftUI

struct ReflectionDisplayView: View {

    // السيناريو اللي انفتح (يجي من الصفحة اللي قبل)
    let scenario: Scenario

    // تنادى لما البوب اب يتسكر (الصفحة اللي ورا تقدر تستخدمها بعدين)
    var onClose: () -> Void = {}

    // الريفلكشن المحفوظ لهالسيناريو
    @State private var entry: ReflectionEntry? = nil

    // هل البوب اب ظاهر
    @State private var showPopup = true

    // كم نزل البوب اب وهو ينسحب
    @State private var dragOffset: CGFloat = 0

    var body: some View {
        ZStack {

            // ===== الصفحة اللي ورا (مشوشة لما البوب اب طالع) =====
            backgroundPage
                .blur(radius: showPopup ? 6 : 0)
                .animation(.easeInOut, value: showPopup)

            // ===== البوب اب =====
            if showPopup {
                popupCard
                    .offset(y: dragOffset)
                    .gesture(dragGesture)
                    .transition(.move(edge: .bottom))
            }
        }
        .onAppear {
            entry = ReflectionStorage().load().last { $0.scenarioID == scenario.id }
        }
    }

    // =========================================================
    // ===== الصفحة اللي ورا =====
    // لما تجهز الصفحة: امسحي كل اللي داخل هذا الـ var
    // واكتبي اسم الصفحة بس، مثلاً:
    //     ReflectionDashboardView()
    // =========================================================
    @ViewBuilder
    private var backgroundPage: some View {
        ZStack {
            Image(.backgruond)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            Text("Background page")
                .font(.title)
                .foregroundStyle(.green2)
        }
    }

    private func close() {
        withAnimation(.easeInOut) {
            showPopup = false
            dragOffset = 0
        }
        onClose()
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                // ينزل بس، ما يطلع فوق
                if value.translation.height > 0 {
                    dragOffset = value.translation.height
                }
            }
            .onEnded { value in
                if value.translation.height > 150 {
                    close()
                } else {
                    withAnimation(.spring()) {
                        dragOffset = 0
                    }
                }
            }
    }

    private var popupCard: some View {
        UnevenRoundedRectangle(topLeadingRadius: 32, topTrailingRadius: 32)
            .fill(.white)
            .frame(height: 640)
            .overlay(alignment: .top) {
                VStack(alignment: .leading, spacing: 16) {

                    RoundedRectangle(cornerRadius: 2)
                        .fill(.yellow1)
                        .frame(width: 58, height: 5.8)
                        .frame(maxWidth: .infinity)

                    HStack {
                        Text(scenario.title)
                            .foregroundStyle(.green2)
                            .font(.title)
                            .bold()
                        Spacer()
                        Button {
                            close()
                        } label: {
                            Image(.x)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 32, height: 32)
                                .frame(width: 44, height: 44)
                        }
                        .buttonStyle(.plain)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Your reflection")
                            .font(.subheadline)
                            .foregroundStyle(.brow)

                        RoundedRectangle(cornerRadius: 20)
                            .fill(.backgru)
                            .frame(height: 160)
                            .overlay(alignment: .topLeading) {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("How are you feeling?")
                                        .font(.title3)
                                        .foregroundStyle(.green2)

                                    HStack(spacing: 8) {

                                        // الوجه 1: Uneasy
                                        RoundedRectangle(cornerRadius: 14)
                                            .fill(entry?.feeling == "Uneasy" ? .yellow1 : .white)
                                            .frame(height: 100)
                                            .overlay {
                                                VStack(spacing: 6) {
                                                    FaceView(smile: -1)
                                                    Text("Uneasy")
                                                        .font(.caption)
                                                        .foregroundStyle(entry?.feeling == "Uneasy" ? .green2 : .gray)
                                                }
                                            }

                                        // الوجه 2: Neutral
                                        RoundedRectangle(cornerRadius: 14)
                                            .fill(entry?.feeling == "Neutral" ? .yellow1 : .white)
                                            .frame(height: 100)
                                            .overlay {
                                                VStack(spacing: 6) {
                                                    FaceView(smile: 0)
                                                    Text("Neutral")
                                                        .font(.caption)
                                                        .foregroundStyle(entry?.feeling == "Neutral" ? .green2 : .gray)
                                                }
                                            }

                                        // الوجه 3: Good
                                        RoundedRectangle(cornerRadius: 14)
                                            .fill(entry?.feeling == "Good" ? .yellow1 : .white)
                                            .frame(height: 100)
                                            .overlay {
                                                VStack(spacing: 6) {
                                                    FaceView(smile: 0.6)
                                                    Text("Good")
                                                        .font(.caption)
                                                        .foregroundStyle(entry?.feeling == "Good" ? .green2 : .gray)
                                                }
                                            }

                                        // الوجه 4: Great
                                        RoundedRectangle(cornerRadius: 14)
                                            .fill(entry?.feeling == "Great" ? .yellow1 : .white)
                                            .frame(height: 100)
                                            .overlay {
                                                VStack(spacing: 6) {
                                                    FaceView(smile: 1)
                                                    Text("Great")
                                                        .font(.caption)
                                                        .foregroundStyle(entry?.feeling == "Great" ? .green2 : .gray)
                                                }
                                            }
                                    }
                                }
                                .padding(12)
                            }
                    }

                    RoundedRectangle(cornerRadius: 20)
                        .fill(.backgru)
                        .frame(height: 190)
                        .overlay(alignment: .topLeading) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("What happened?")
                                    .font(.title3)
                                    .foregroundStyle(.green2)

                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.white)
                                    .frame(height: 120)
                                    .overlay(alignment: .topLeading) {
                                        Text(entry?.reflectionText ?? "No reflection yet")
                                            .font(.body)
                                            .foregroundStyle(entry == nil ? .gray : .brow)
                                            .padding(14)
                                    }
                            }
                            .padding(16)
                        }
                }
                .padding(.horizontal, 20)
                .padding(.top, 14)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea(edges: .bottom)
    }
}

// FaceView موجود في ReflectionView.swift

#Preview {
    ReflectionDisplayView(scenario: Scenario.examples[0])
}
