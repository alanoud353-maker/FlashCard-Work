import SwiftUI
import AVFAudio
 
// MARK: - Colors

 
extension Color {
    static let practiceGreen = Color(red: 0.34, green: 0.44, blue: 0.25)
    static let practiceDarkGreen = Color(red: 0.25, green: 0.32, blue: 0.22)
    static let practiceCream = Color(red: 1.0, green: 0.98, blue: 0.91)
    static let practiceYellow = Color(red: 0.98, green: 0.88, blue: 0.59, opacity: 0.6)
}

    
// MARK: - Response Card
 
private struct ResponseCard: View {
    let text: String
    let playLabel: String
    let isPlaying: Bool
    let onPlay: () -> Void
    
    var body: some View {
        
            HStack(spacing: 12) {
                Text(text)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button(action: onPlay) {
                    Image(systemName: isPlaying ? "stop.circle.fill" : "play.circle.fill")
                        .font(.title)
                        .foregroundStyle(Color.practiceGreen)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(playLabel)
            }
            .font(.body)
            .multilineTextAlignment(.leading)
            .padding(14)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.practiceCream)
            }
            .shadow(color: .black.opacity(0.08), radius: 3, x: 0, y: 2)
        }
    }
    
    // MARK: - Main View
    
    struct ScenarioPracticeView: View {
        let scenario: Scenario
        @Environment(\.dismiss) private var dismiss
        @State private var audioRecorder = AudioRecorder()
        @State private var speaker = Speaker()
        @State private var isStartingRecording = false
        @State private var recordingError: String?
        @State private var showsReflection = false
        @State private var recordingStartTask: Task<Void, Never>?
        var body: some View {
            VStack(spacing: 16) {
                header
                promptPanel
                    .layoutPriority(1)
                recordingSection
                reflectButton
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background {
                Image("SplashBackgroundImage")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .accessibilityHidden(true)
            }
            .navigationBarBackButtonHidden(true)
            .sheet(isPresented: $showsReflection) {
                ReflectionView(scenario: scenario) {
                    dismiss() // 👈 هذا السطر الذي يقفل ScenarioPracticeView ويظهر ContentView
                }
                .presentationDetents([.height(640)])
                .presentationDragIndicator(.hidden)
                .presentationCornerRadius(32)
            }
            .onDisappear {
                recordingStartTask?.cancel()
                speaker.stop()
                audioRecorder.stopPlayback()
                audioRecorder.stopRecording()
            }
        }
        
        // MARK: Header
        
        private var header: some View {
            HStack(spacing: 8) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color(red: 0.15, green: 0.25, blue: 0.15))
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Back")
                
                Text(scenario.title)
                    .font(.title)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                
                    .padding()
                    .accessibilityHidden(true)
            }
            .padding(.bottom, 8)
        }
        
        // MARK: Prompt + Responses
        
        private var promptPanel: some View {
            VStack(spacing: 14) {
                Text(scenario.prompt)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.practiceDarkGreen)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.vertical, 8)
                
                ForEach(scenario.responses, id: \.self) { response in
                    ResponseCard(
                        text: response,
                        playLabel: "Play response",
                        isPlaying: speaker.speakingText == response
                    ) {
                        audioRecorder.stopPlayback()
                        speaker.toggle(response)
                    }
                    .disabled(audioRecorder.isRecording || isStartingRecording)
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color.practiceYellow)
            }
            .shadow(color: .black.opacity(0.12), radius: 6, x: 0, y: 4)
        }
        
        // MARK: Recording
        
        private var recordingSection: some View {
            VStack(spacing: 12) {
                if audioRecorder.isRecording {
                    recordingState
                } else if audioRecorder.hasRecording {
                    completedState
                } else {
                    idleState
                }
                
                if let message = recordingError ?? audioRecorder.lastError {
                    Text(message)
                        .font(.callout)
                        .multilineTextAlignment(.center)
                }
            }
            .foregroundStyle(Color.practiceGreen)
        }
        
        private var recordingState: some View {
            RecordingReviewCard(
                isRecording: true,
                isPlaying: false,
                isDeleting: false,
                levels: audioRecorder.levels,
                duration: audioRecorder.duration,
                onPlayback: { audioRecorder.stopRecording() },
                onRetry: {}
            )
        }

        private var completedState: some View {
            RecordingReviewCard(
                isRecording: false,
                isPlaying: audioRecorder.isPlaying,
                isDeleting: audioRecorder.isDeleting,
                levels: audioRecorder.levels,
                duration: audioRecorder.duration,
                onPlayback: {
                    if audioRecorder.isPlaying {
                        audioRecorder.stopPlayback()
                    } else {
                        speaker.stop()
                        audioRecorder.replayRecording()
                    }
                },
                onRetry: {
                    Task {
                        do {
                            try await audioRecorder.deleteRecording()
                            recordingError = nil
                        } catch {
                            recordingError = "Could not delete recording. Please try again."
                        }
                    }
                }
            )
        }

        private var idleState: some View {
            Button {
                recordingStartTask = Task { await beginRecording() }
            } label: {
                VStack(spacing: 4) {
                    Image(systemName: "mic")
                        .font(.title)
                        .frame(width: 64, height: 64)
                        .background {
                            Circle()
                                .fill(Color.practiceGreen.opacity(0.1))
                        }
                    
                    Text("Tap to Speak")
                        .font(.body)
                }
            }
            .disabled(isStartingRecording)
            .accessibilityLabel("Record your response")
        }
        
        private func beginRecording() async {
            guard !isStartingRecording else { return }
            
            speaker.stop()
            isStartingRecording = true
            recordingError = nil
            defer { isStartingRecording = false }
            
            let permissionGranted = await AVAudioApplication.requestRecordPermission()
            
            guard !Task.isCancelled else { return }
            guard permissionGranted else {
                recordingError = "Allow microphone access in Settings to record."
                return
            }
            
            do {
                try await audioRecorder.startRecording()
            } catch is CancellationError {
                return
            } catch {
                recordingError = "Could not start recording. Please try again."
            }
        }
        
        // MARK: Reflect
        
        private var reflectButton: some View {
            Button {
                recordingStartTask?.cancel()
                speaker.stop()
                audioRecorder.stopPlayback()
                audioRecorder.stopRecording()
                showsReflection = true
            } label: {
                Text("Reflect")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 38)
                    .padding(.vertical, 14)
                    .background {
                        Capsule()
                            .fill(Color.practiceGreen)
                    }
                    .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 4)
            }
        }
    }
    
    #Preview {
        ScenarioPracticeView(scenario: Scenario.examples[0])
    }

