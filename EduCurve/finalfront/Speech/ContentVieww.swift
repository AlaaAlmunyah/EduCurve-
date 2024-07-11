import SwiftUI
import InstantSearchVoiceOverlay

struct ContentVieww: View {
    @State private var isRecording: Bool = false
    @State private var speechText: String = ""
    
    var body: some View {
        VStack {
            Button(action: {
                if self.isRecording {
                    self.stopRecording()
                } else {
                    self.startRecording()
                }
            }) {
                Text(isRecording ? "Stop Recording" : "Start Recording")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                    .background(isRecording ? Color.red : Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
    }

    private func startRecording() {
        self.isRecording = true
        if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
            CustomVoiceOverlayController.shared.voiceOverlayController.start(on: rootViewController, textHandler: { text, final, _ in
                self.speechText = text
                if final {
                    self.stopRecording()
                    print("Final text: \(text)")
                }
            }, errorHandler: { error in
                print("Voice overlay error: \(String(describing: error))")
                self.isRecording = false
            })
        } else {
            print("Root view controller not found")
            self.isRecording = false
        }
    }

    private func stopRecording() {
        self.isRecording = false
        // The voiceOverlayController stops automatically when done
    }
}

import InstantSearchVoiceOverlay

class CustomVoiceOverlayController {
    static let shared = CustomVoiceOverlayController()
    
    let voiceOverlayController: VoiceOverlayController
    
    private init() {
        self.voiceOverlayController = VoiceOverlayController()
        customizeVoiceOverlaySettings()
    }
    
    private func customizeVoiceOverlaySettings() {
        let settings = voiceOverlayController.settings
        
        // Customize permission screen
        settings.layout.permissionScreen.title = "We need your permission"
        settings.layout.permissionScreen.subtitle = "Allow us to use your microphone for voice commands."
        settings.layout.permissionScreen.allowText = "Allow Access"
        settings.layout.permissionScreen.rejectText = "Deny Access"
        settings.layout.permissionScreen.textColor = .black
        settings.layout.permissionScreen.backgroundColor = .white
        settings.layout.permissionScreen.startGradientColor = .blue
        settings.layout.permissionScreen.endGradientColor = .purple

        // Customize no permission screen
        settings.layout.noPermissionScreen.title = "Microphone Access Denied"
        settings.layout.noPermissionScreen.subtitle = "Please enable microphone access in your settings."
        settings.layout.noPermissionScreen.permissionEnableText = "Enable in Settings"
        settings.layout.noPermissionScreen.doneText = "Done"
        settings.layout.noPermissionScreen.textColor = .white
        settings.layout.noPermissionScreen.backgroundColor = .red
        settings.layout.noPermissionScreen.startGradientColor = .orange
        settings.layout.noPermissionScreen.endGradientColor = .yellow

        // Customize input screen
        settings.layout.inputScreen.titleInitial = "Press to start recording"
        settings.layout.inputScreen.titleListening = "Listening..."
        settings.layout.inputScreen.subtitleInitial = "You can say things like:"
        settings.layout.inputScreen.subtitleBulletList = ["\"Set a timer for 5 minutes\"", "\"What's the weather today?\""]
        settings.layout.inputScreen.titleInProgress = "Processing your request..."
        settings.layout.inputScreen.titleError = "Sorry, I didn't catch that"
        settings.layout.inputScreen.subtitleError = "Please try again"
        settings.layout.inputScreen.textColor = .white
        settings.layout.inputScreen.backgroundColor = .darkGray
        settings.layout.inputScreen.inputButtonConstants.pulseColor = .blue
        settings.layout.inputScreen.inputButtonConstants.pulseDuration = 3
        settings.layout.inputScreen.inputButtonConstants.pulseRadius = 80

        // Customize result screen
        settings.layout.resultScreen.title = "Processing..."
        settings.layout.resultScreen.subtitle = "Please wait a moment"
        settings.layout.resultScreen.startAgainText = "Try Again"
        settings.layout.resultScreen.textColor = .black
        settings.layout.resultScreen.backgroundColor = .lightGray
        
        print("Custom settings applied: \(settings.layout)")
    }
}


struct ContentVieww_Previews: PreviewProvider {
    static var previews: some View {
        ContentVieww()
    }
}
