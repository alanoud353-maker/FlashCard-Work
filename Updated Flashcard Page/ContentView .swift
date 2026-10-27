import SwiftUI
import AVFAudio
 
// MARK: - Colors


 
extension Color {
    static let practiceGreen = Color(red: 0.34, green: 0.44, blue: 0.25)
    static let practiceDarkGreen = Color(red: 0.25, green: 0.32, blue: 0.22)
    static let practiceCream = Color(red: 1.0, green: 0.98, blue: 0.91)
    static let practiceYellow = Color(red: 0.98, green: 0.88, blue: 0.59)
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
    
    struct ContentView: View {
        let scenario: Scenario
        @Environment(\.dismiss) private var dismiss
        @State private var audioRecorder = AudioRecorder()
        @State private var speaker = Speaker()
        @State private var isStartingRecording = false
        @State private var recordingError: String?
        var body: some View {
            ScrollView {
                VStack(spacing: 24) {
                    header
                    promptPanel
                    recordingSection
                        .padding(.top, -8)
                    reflectButton
                        .padding(.top, -8)
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 24)
            }
            .background {
                Image(.backgroundYellow)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .accessibilityHidden(true)
            }
            .navigationBarBackButtonHidden(true)
            .onDisappear {
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
                    Image(systemName: "arrow.left")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(Color.practiceGreen)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Back")
                
                Text(scenario.title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                
                Color.clear
                    .frame(width: 44, height: 44)
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
                
                ForEach(scenario.responses.indices, id: \.self) { index in
                    ResponseCard(
                        text: scenario.responses[index],
                        playLabel: "Play response \(index + 1)",
                        isPlaying: speaker.speakingText == scenario.responses[index]
                    ) {
                        speaker.toggle(scenario.responses[index])
                    }
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
            VStack(spacing: 12) {
                HStack(spacing: 20) {
                    HStack(alignment: .center, spacing: 2.5) {
                        ForEach(audioRecorder.levels.indices, id: \.self) { index in
                            Capsule()
                                .fill(Color.practiceGreen)
                                .frame(
                                    width: 3,
                                    height: max(4, CGFloat(audioRecorder.levels[index]) * 56)
                                )
                        }
                    }
                    .frame(width: 180, height: 56)
                    .animation(.easeOut(duration: 0.12), value: audioRecorder.levels)
                    .accessibilityHidden(true)
                    
                    Button {
                        audioRecorder.stopRecording()
                    } label: {
                        Image(systemName: "stop.fill")
                            .font(.title2)
                            .frame(width: 44, height: 44)
                            .contentShape(Rectangle())
                    }
                    .accessibilityLabel("Stop recording")
                }
                
                Text("Recording…")
                    .font(.body)
            }
        }
        
        private var completedState: some View {
            HStack(spacing: 16) {
                Button {
                    if audioRecorder.isPlaying {
                        audioRecorder.stopPlayback()
                    } else {
                        audioRecorder.replayRecording()
                    }
                } label: {
                    Image(systemName: audioRecorder.isPlaying ? "stop.circle.fill" : "play.circle.fill")
                        .font(.title)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
                .disabled(audioRecorder.isDeleting)
                .accessibilityLabel(audioRecorder.isPlaying ? "Stop playback" : "Play your recording")
                
                Text("Recording complete")
                
                Button {
                    Task {
                        do {
                            try await audioRecorder.deleteRecording()
                            recordingError = nil
                        } catch {
                            recordingError = "Could not delete recording. Please try again."
                        }
                    }
                } label: {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
                .disabled(audioRecorder.isDeleting)
                .accessibilityLabel("Delete recording")
                .accessibilityHint("Lets you record your response again.")
            }
        }
        
        private var idleState: some View {
            Button {
                Task { await beginRecording() }
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
            
            print("1 asking permission")
            let permissionGranted = await AVAudioApplication.requestRecordPermission()
            print("2 permission:", permissionGranted)
            
            guard permissionGranted else {
                recordingError = "Allow microphone access in Settings to record."
                return
            }
            
            do {
                print("3 starting recorder")
                try await audioRecorder.startRecording()
                print("4 recording started")
            } catch {
                print("ERROR:", error)
                recordingError = "Could not start recording. Please try again."
            }
        }
        
        // MARK: Reflect
        
        private var reflectButton: some View {
            Button {
                // TODO: handle reflection.
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
        ContentView(scenario: Scenario.all[0])
    }

