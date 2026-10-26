import SwiftUI

struct SplashView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var cardsVisible = false

    var body: some View {
        GeometryReader { geometry in
            let width = min(geometry.size.width - 32, geometry.size.height - 32,
                            SplashConfiguration.maximumSize)
            let scale = max(1, width) / 862

            ZStack {
                GeometryReader { backgroundGeometry in
                    Image("SplashBackgroundImage")
                        .resizable()
                        .scaledToFill()
                        .frame(width: backgroundGeometry.size.width, height: backgroundGeometry.size.height)
                        .clipped()
                }
                .ignoresSafeArea()
                .allowsHitTesting(false)
                .accessibilityHidden(true)
                artwork
                    .frame(width: 862, height: 848)
                    .scaleEffect(scale)
                    .frame(width: 862 * scale, height: 848 * scale)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Ice Breakers")
        .task {
            cardsVisible = true
        }
    }

    private var artwork: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: SplashConfiguration.folderCornerRadius)
                .fill(Color("SplashFolderBack"))
                .frame(width: 518, height: 424)
                .position(x: 439, y: 432)

            ForEach(SplashConfiguration.cards) { card in
                SplashCardView(card: card)
                    .rotationEffect(.degrees(card.angle))
                    .position(x: card.x, y: card.y)
                    .offset(y: cardsVisible || reduceMotion ? 0 : -600)
                    .opacity(cardsVisible || reduceMotion ? 1 : 0)
                    .animation(
                        reduceMotion ? nil : .spring(duration: 0.65, bounce: 0.22).delay(card.delay),
                        value: cardsVisible
                    )
            }

            RoundedRectangle(cornerRadius: SplashConfiguration.folderCornerRadius)
                .fill(Color("SplashFolderFront"))
                .frame(width: 518, height: 288)
                .position(x: 439, y: 500)

            Capsule()
                .fill(Color("SplashTab"))
                .frame(width: 145, height: 26)
                .position(x: 316, y: 434)
        }
        .clipped()
    }
}

private struct SplashCardView: View {
    let card: SplashCardConfiguration

    var body: some View {
        RoundedRectangle(cornerRadius: SplashConfiguration.cardCornerRadius)
            .fill(Color(card.colorName))
            .overlay(alignment: .topLeading) {
                if let imageName = card.imageName {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .padding(24)
                } else {
                    VStack(alignment: .leading, spacing: 26) {
                        Capsule().frame(width: 94, height: 21)
                        Capsule().frame(width: 122, height: 21)
                    }
                    .foregroundStyle(Color("SplashCardLines"))
                    .padding(.top, 52)
                    .padding(.leading, 32)
                }
            }
            .frame(width: SplashConfiguration.cardWidth, height: SplashConfiguration.cardHeight)
            .clipShape(RoundedRectangle(cornerRadius: SplashConfiguration.cardCornerRadius))
    }
}

struct AppStartView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var showsSplash = true

    var body: some View {
        ZStack {
            if showsSplash {
                SplashView()
                    .transition(.opacity)
            } else {
                ContentView()
                    .transition(.opacity)
            }
        }
        .task {
            do {
                try await Task.sleep(for: .seconds(SplashConfiguration.duration))
                try Task.checkCancellation()
                withAnimation(reduceMotion ? nil : .easeOut(duration: 0.3)) {
                    showsSplash = false
                }
            } catch {
                // A cancelled task must not dismiss a newly presented splash.
            }
        }
    }
}

#Preview("Splash") {
    SplashView()
}

#Preview("App opening") {
    AppStartView()
}
