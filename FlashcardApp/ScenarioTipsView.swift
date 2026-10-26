import SwiftUI

struct ScenarioTipsView: View {
    let category: ScenarioCategory
    let onClose: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Label("Tips", systemImage: "lightbulb")
                    .font(.title2.bold())
                Spacer()
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.headline)
                        .frame(width: 44, height: 44)
                        .background(Color("Gold").opacity(0.25), in: Circle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Close tips")
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 12)

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(category.title)
                        .font(.title3.bold())
                    Text("Rules")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Color("OliveGreen"))

                    VStack(spacing: 12) {
                        ForEach(Array(category.tips.enumerated()), id: \.element.id) { index, tip in
                            ScenarioTipRow(number: index + 1, tip: tip)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
        .foregroundStyle(Color("PrimaryGreen"))
        .background(Color("Cream"))
        .accessibilityAction(.escape, onClose)
    }
}

private struct ScenarioTipRow: View {
    let number: Int
    let tip: ScenarioTip

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Text(number, format: .number)
                .font(.headline)
                .frame(minWidth: 32, minHeight: 32)
                .background(Color("Gold").opacity(0.3), in: Circle())

            VStack(alignment: .leading, spacing: 6) {
                Text(tip.title)
                    .font(.headline)
                if !tip.detail.isEmpty {
                    Text(tip.detail)
                        .font(.body)
                        .foregroundStyle(Color("Brown"))
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(18)
        .background(.white, in: RoundedRectangle(cornerRadius: 20))
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    ScenarioTipsView(category: .icebreakers, onClose: {})
        .frame(width: 350, height: 520)
}
