import Foundation
import AVFAudio
import Observation

@MainActor
@Observable
final class AudioRecorder {
    private(set) var isRecording = false
    private(set) var hasRecording = false
    private(set) var duration: TimeInterval = 0
    @ObservationIgnored private var recordingStartedAt: Date?
    private(set) var audioLevel: Float = 0
    private(set) var waveformSamples: [Float] = []
    private(set) var lastError: String?
    private(set) var isPlaying = false
    private(set) var isDeleting = false
    private(set) var levels: [Float] = Array(repeating: 0, count: 30)
    @ObservationIgnored private var bufferCounter = 0

    @ObservationIgnored private var playbackTask: Task<Void, Never>?

    @ObservationIgnored private let capture = MicrophoneCapture()
    @ObservationIgnored private var sampleTask: Task<Void, Never>?
    private var recordingURL: URL?
    private var isStarting = false
    private var isStopping = false
    private var stopRequested = false

    func startRecording() async throws {
        guard !isRecording, !hasRecording, !isStarting, !isStopping, !isPlaying, !isDeleting else { return }
        isStarting = true
        stopRequested = false
        lastError = nil
        defer { isStarting = false }

        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("caf")

        do {
            let stream = try await capture.start(at: url)
            if stopRequested || Task.isCancelled {
                await capture.stop()
                throw CancellationError()
            }
            recordingURL = url
            waveformSamples = []
            levels = Array(repeating: 0, count: 30)
            bufferCounter = 0
            duration = 0
            recordingStartedAt = Date()
            isRecording = true

            sampleTask = Task { [weak self] in
                do {
                    for try await samples in stream {
                        guard !Task.isCancelled else { return }
                        if let start = self?.recordingStartedAt {
                            self?.duration = Date().timeIntervalSince(start)
                        }
                        self?.waveformSamples = samples
                        self?.audioLevel = samples.map { abs($0) }.max() ?? 0
                        self?.addLevel(from: samples)
                    }
                } catch {
                    self?.lastError = error.localizedDescription
                    self?.stopRecording()
                }
            }
        } catch {
            try? FileManager.default.removeItem(at: url)
            throw error
        }
    }

    private func addLevel(from samples: [Float]) {
        bufferCounter += 1
        guard bufferCounter % 3 == 0 else { return }
        var level: Float = 0
        if !samples.isEmpty {
            let sum = samples.reduce(0) { $0 + $1 * $1 }
            level = sqrt(sum / Float(samples.count))
        }
        levels.append(min(1, level * 1.6))
        if levels.count > 30 {
            levels.removeFirst(levels.count - 30)
        }
    }

    func stopRecording() {
        stopRequested = true
        guard isRecording, !isStopping else { return }
        isStopping = true
        sampleTask?.cancel()
        sampleTask = nil

        Task {
            await capture.stop()
            if let recordingURL, let file = try? AVAudioFile(forReading: recordingURL),
               file.processingFormat.sampleRate > 0 {
                duration = Double(file.length) / file.processingFormat.sampleRate
            }
            recordingStartedAt = nil
            isRecording = false
            hasRecording = recordingURL != nil
            audioLevel = 0
            waveformSamples = []
            isStopping = false
        }
    }

    func replayRecording() {
        guard hasRecording, !isRecording, !isStopping, !isPlaying,
              !isDeleting, let recordingURL else { return }
        lastError = nil
        isPlaying = true

        playbackTask = Task {
            defer { isPlaying = false }
            do {
                try await capture.replay(at: recordingURL)
            } catch is CancellationError {
                // Stopping playback is a normal user action.
            } catch {
                lastError = error.localizedDescription
            }
        }
    }

    func stopPlayback() {
        playbackTask?.cancel()
    }

    func deleteRecording() async throws {
        guard !isRecording, !isStarting, !isStopping, !isDeleting,
              let recordingURL else { return }
        isDeleting = true
        defer { isDeleting = false }
        stopPlayback()
        await playbackTask?.value
        playbackTask = nil
        try FileManager.default.removeItem(at: recordingURL)
        self.recordingURL = nil
        hasRecording = false
        duration = 0
        recordingStartedAt = nil
        levels = Array(repeating: 0, count: 30)
        waveformSamples = []
        audioLevel = 0
        lastError = nil
    }
}

// Owns audio hardware work away from the main actor.
private actor MicrophoneCapture {
    private var engine: AVAudioEngine?
    private var player: AVAudioPlayer?
    private var continuation: AsyncThrowingStream<[Float], Error>.Continuation?

    func start(at url: URL) async throws -> AsyncThrowingStream<[Float], Error> {
        do {
            #if os(iOS)
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try session.setActive(true)
            #endif

            let newEngine = AVAudioEngine()
            let input = newEngine.inputNode
            let format = input.outputFormat(forBus: 0)
            guard format.sampleRate > 0, format.channelCount > 0 else {
                throw NSError(domain: "AudioRecording", code: 2,
                    userInfo: [NSLocalizedDescriptionKey: "No microphone input is available."])
            }

            let file = try AVAudioFile(
                forWriting: url,
                settings: format.settings,
                commonFormat: format.commonFormat,
                interleaved: format.isInterleaved
            )
            let (stream, output) = AsyncThrowingStream<[Float], Error>
                .makeStream(bufferingPolicy: .bufferingNewest(1))

            input.installTap(onBus: 0, bufferSize: 1024, format: format) {
                @Sendable buffer, _ in
                do {
                    try file.write(from: buffer)
                    output.yield(Self.waveform(from: buffer))
                } catch {
                    output.finish(throwing: error)
                }
            }
            engine = newEngine
            continuation = output
            newEngine.prepare()
            try newEngine.start()
            return stream
        } catch {
            await stop()
            throw error
        }
    }

    func replay(at url: URL) async throws {
        do {
            try Task.checkCancellation()
            #if os(iOS)
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default)
            try session.setActive(true)
            #endif

            try Task.checkCancellation()
            let newPlayer = try AVAudioPlayer(contentsOf: url)
            player = newPlayer
            guard newPlayer.play() else {
                throw NSError(domain: "AudioRecording", code: 4,
                    userInfo: [NSLocalizedDescriptionKey: "Could not play the recording."])
            }
            while newPlayer.isPlaying {
                try await Task.sleep(for: .milliseconds(50))
            }
            try Task.checkCancellation()
        } catch {
            await stop()
            throw error
        }
        await stop()
    }

    func stop() async {
        player?.stop()
        player = nil
        if let engine {
            engine.stop()
            engine.inputNode.removeTap(onBus: 0)
            self.engine = nil
        }
        continuation?.finish()
        continuation = nil

        #if os(iOS)
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        #endif
    }

    nonisolated private static func waveform(
        from buffer: AVAudioPCMBuffer
    ) -> [Float] {
        guard let channel = buffer.floatChannelData?[0] else { return [] }
        // A fixed 20 ms window preserves the relationship between pitch and spacing.
        let count = min(Int(buffer.frameLength), Int(buffer.format.sampleRate * 0.02))
        guard count > 1 else { return [] }
        let stride = Int(buffer.stride)
        var sum: Float = 0
        for index in 0..<count {
            let value = channel[index * stride]
            sum += value * value
        }
        // Suppress very quiet background noise so the line rests flat.
        guard sqrt(sum / Float(count)) > 0.003 else { return [] }

        return (0..<256).map { index in
            let position = index * (count - 1) / 255
            return max(-1, min(1, channel[position * stride] * 4))
        }
    }
}
