import SwiftUI

struct VoiceWaveform: View {
    let samples: [Float]

    var body: some View {
        Canvas { context, size in
            var path = Path()
            let middle = size.height / 2

            if samples.count < 2 {
                path.move(to: CGPoint(x: 0, y: middle))
                path.addLine(to: CGPoint(x: size.width, y: middle))
            } else {
                for index in samples.indices {
                    let x = CGFloat(index)
                        / CGFloat(samples.count - 1)
                        * size.width

                    let value = CGFloat(
                        max(-1, min(1, samples[index]))
                    )
                    let y = middle - value * (middle - 3)
                    let point = CGPoint(x: x, y: y)

                    if index == 0 {
                        path.move(to: point)
                    } else {
                        path.addLine(to: point)
                    }
                }
            }

            context.stroke(
                path,
                with: .color(.white),
                style: StrokeStyle(
                    lineWidth: 2,
                    lineCap: .round,
                    lineJoin: .round
                )
            )
        }
        .frame(width: 145, height: 48)
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
        .background {
            Capsule()
                .fill(Color(red: 0.34, green: 0.44, blue: 0.25))
        }
        .accessibilityHidden(true)
    }
}

