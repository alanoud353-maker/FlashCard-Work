import SwiftUI

struct RecordingReviewCard: View {
    let isRecording: Bool
    let isPlaying: Bool
    let isDeleting: Bool
    let levels: [Float]
    let duration: TimeInterval
    let onPlayback: () -> Void
    let onRetry: () -> Void

    private var timeLabel: String {
        let seconds = max(0, Int(duration))
        return String(format: "%d:%02d", seconds / 60, seconds % 60)
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                if !isRecording {
                    playbackButton
                }

                RecordingLevelBars(levels: levels, isRecording: isRecording)
                    .frame(maxWidth: .infinity)
                    .frame(height: 42)
                    .accessibilityHidden(true)

                Text(timeLabel)
                    .font(.system(.body, design: .monospaced).weight(.medium))
                    .monospacedDigit()
                    .fixedSize()
                    .accessibilityLabel("Recording duration")
                    .accessibilityValue(Text(timeLabel))

                if isRecording {
                    playbackButton
                } else {
                    Button(action: onRetry) {
                        ZStack {
                            Circle().fill(Color.practiceGreen)
                            if isDeleting {
                                ProgressView().controlSize(.small)
                            } else {
                                Image(systemName: "trash")
                                    .font(.title3)
                                    .foregroundStyle(Color.white)
                            }
                        }
                        .frame(width: 48, height: 48)
                    }
                    .buttonStyle(.plain)
                    .disabled(isDeleting)
                    .accessibilityLabel("Delete recording")
                    .accessibilityHint("Lets you record your response again.")
                }
            }
            .padding(10)
            .padding(.leading, isRecording ? 10 : 0)
            .background(Color.practiceCream, in: Capsule())
            .overlay {
                Capsule()
                    .stroke(Color.practiceDarkGreen.opacity(0.18), lineWidth: 1)
            }

            HStack(spacing: 8) {
                if isRecording {
                    Circle()
                        .fill(Color("Gold"))
                        .frame(width: 8, height: 8)
                        .accessibilityHidden(true)
                }
                Text(isRecording ? "Recording…" : isPlaying ? "Playing recording…" : "Recording complete")
                    .font(.subheadline)
            }
        }
        .foregroundStyle(Color.practiceDarkGreen)
    }

    private var playbackButton: some View {
        Button(action: onPlayback) {
            Image(systemName: isRecording || isPlaying ? "stop.fill" : "play.fill")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 48, height: 48)
                .background(Color.practiceGreen, in: Circle())
        }
        .buttonStyle(.plain)
        .disabled(isDeleting)
        .accessibilityLabel(isRecording ? "Stop recording" : isPlaying ? "Stop playback" : "Play your recording")
    }
}

private struct RecordingLevelBars: View {
    let levels: [Float]
    let isRecording: Bool

    var body: some View {
        Canvas { context, size in
            let count = max(1, levels.count)
            let step = size.width / CGFloat(count)
            let width = max(1, min(3, step * 0.55))
            for (index, level) in levels.enumerated() {
                let height = max(4, CGFloat(min(1, max(0, level))) * size.height)
                let rect = CGRect(
                    x: CGFloat(index) * step + (step - width) / 2,
                    y: (size.height - height) / 2,
                    width: width, height: height
                )
                context.fill(
                    Path(roundedRect: rect, cornerRadius: width / 2),
                    with: .color(Color.practiceGreen.opacity(isRecording ? 1 : 0.5))
                )
            }
        }
    }
}

#Preview("Recording") {
    RecordingReviewCard(
        isRecording: true, isPlaying: false, isDeleting: false,
        levels: [0.2, 0.5, 0.8, 0.3, 0.6, 0.9, 0.4, 0.2],
        duration: 7, onPlayback: {}, onRetry: {}
    )
    .padding(20)
    .background(Color.practiceCream)
}

#Preview("Recording complete") {
    RecordingReviewCard(
        isRecording: false, isPlaying: false, isDeleting: false,
        levels: [0.2, 0.5, 0.8, 0.3, 0.6, 0.9, 0.4, 0.2],
        duration: 7, onPlayback: {}, onRetry: {}
    )
    .padding(20)
    .background(Color.practiceCream)
}
