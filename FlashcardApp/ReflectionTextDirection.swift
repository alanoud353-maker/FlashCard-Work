import SwiftUI

enum ReflectionTextDirection {
    static func layoutDirection(for text: String) -> LayoutDirection {
        // Ignore spaces, numbers, and punctuation before the first letter.
        guard let letter = text.unicodeScalars.first(where: {
            CharacterSet.letters.contains($0)
        }) else {
            return .leftToRight
        }

        switch letter.value {
        case 0x0600...0x06FF, 0x0750...0x077F, 0x0870...0x089F,
             0x08A0...0x08FF, 0xFB50...0xFDFF, 0xFE70...0xFEFF,
             0x1EE00...0x1EEFF:
            return .rightToLeft
        default:
            return .leftToRight
        }
    }
}

extension View {
    func reflectionTextDirection(for text: String) -> some View {
        self
            .multilineTextAlignment(.leading)
            .environment(\.layoutDirection, ReflectionTextDirection.layoutDirection(for: text))
    }
}
