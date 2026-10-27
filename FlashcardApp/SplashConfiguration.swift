import SwiftUI

// Edit these values to customize the splash without changing its animation code.
enum SplashConfiguration {
    static let duration: Double = 3
    static let maximumSize: CGFloat = 430
    static let tileCornerRadius: CGFloat = 165
    static let folderCornerRadius: CGFloat = 50
    static let cardCornerRadius: CGFloat = 34
    static let cardWidth: CGFloat = 185
    static let cardHeight: CGFloat = 280

    // Coordinates use an 862 × 848 design canvas, matching the reference video.
    // imageName: add an Image Set to Assets and enter its name to replace the lines.
    static let cards: [SplashCardConfiguration] = [
        .init(id: "one", colorName: "SplashCardOne", x: 382, y: 350, angle: -14, delay: 0.05),
        .init(id: "two", colorName: "SplashCardTwo", x: 455, y: 325, angle: -8, delay: 0.20),
        .init(id: "three", colorName: "SplashCardThree", x: 525, y: 320, angle: 2, delay: 0.35),
        .init(id: "four", colorName: "SplashCardFour", x: 607, y: 300, angle: 8, delay: 0.50)
    ]
}

struct SplashCardConfiguration: Identifiable {
    let id: String
    var colorName: String
    var x: CGFloat
    var y: CGFloat
    var angle: Double
    var delay: Double
    var imageName: String? = nil
}
