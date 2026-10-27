import SwiftUI

struct SplashView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var cardsVisible = false
    @State private var showsShortName = false

    var body: some View {
        GeometryReader { geometry in
            let width = min(geometry.size.width - 32, max(1, geometry.size.height - 160),
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
                    .offset(y: -40)
                    .opacity(showsShortName ? 1 : 0)

                SplashNameMotion(
                    isCondensed: showsShortName,
                    nameOffset: width * 0.32,
                    reduceMotion: reduceMotion
                )
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(SplashConfiguration.fullName))
        .task {
            do {
                try await Task.sleep(for: .seconds(SplashConfiguration.fullNameDuration))
                try Task.checkCancellation()
                withAnimation(reduceMotion ? nil : .easeInOut(duration: SplashConfiguration.nameTransitionDuration)) {
                    showsShortName = true
                }
                cardsVisible = true
            } catch {
                // Stop the sequence if the splash disappears.
            }
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

// Every letter keeps its identity while moving from its word to the logo name.
private struct SplashNameMotion: View {
    let isCondensed: Bool
    let nameOffset: CGFloat
    let reduceMotion: Bool

    private struct Letter: Identifiable {
        let id: Int
        let original: String
        let row: Int
        let column: Int
        let wordLength: Int
        let destination: Int?
    }

    private static let letters: [Letter] = {
        let words = ["converse", "In", "Confidence"]
        let selected = [0, 1, 2, 9, 10, 11, 12]
        var letters: [Letter] = []
        var id = 0
        for (row, word) in words.enumerated() {
            for (column, character) in word.enumerated() {
                letters.append(Letter(
                    id: id, original: String(character), row: row,
                    column: column, wordLength: word.count,
                    destination: selected.firstIndex(of: id)
                ))
                id += 1
            }
        }
        return letters
    }()

    private static let shortLetters = Array(SplashConfiguration.shortName).map(String.init)

    var body: some View {
        GeometryReader { geometry in
            let fontSize = min(38.0, max(16.0, (geometry.size.width - 48) / 6.5))
            let step = fontSize * 0.62
            ForEach(Self.letters) { letter in
                let isKept = letter.destination != nil
                let originalX = geometry.size.width / 2
                    + (CGFloat(letter.column) - CGFloat(letter.wordLength - 1) / 2) * step
                let originalY = geometry.size.height / 2 + CGFloat(letter.row - 1) * fontSize * 1.6
                let finalX = geometry.size.width / 2
                    + (CGFloat(letter.destination ?? 3) - 3) * step
                let finalY = geometry.size.height / 2 + nameOffset

                Text(isCondensed && isKept
                     ? Self.shortLetters[letter.destination ?? 0] : letter.original)
                    .font(.system(size: fontSize, weight: .bold, design: .rounded).monospaced())
                    .foregroundStyle(Color("PrimaryGreen"))
                    .opacity(isCondensed && !isKept ? 0 : 1)
                    .position(
                        x: isCondensed && isKept ? finalX : originalX,
                        y: isCondensed && isKept ? finalY : originalY
                    )
                    .animation(
                        reduceMotion ? nil :
                            .spring(duration: SplashConfiguration.nameTransitionDuration, bounce: 0.12)
                            .delay(Double(letter.destination ?? 0) * 0.06),
                        value: isCondensed
                    )
            }
        }
        .accessibilityHidden(true)
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
                CategoryView()
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
