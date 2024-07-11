import SwiftUI
import InstantSearchVoiceOverlay

struct SpeechReviewView: View {
    var incorrectQuestions: [Question]
    @State private var isRecording: Bool = false
    @State private var speechText: String = ""
    @State private var highlightedText: AttributedString = AttributedString("")
    @State private var correctStatement: String = ""

    private let apiKey = "API-KEY"
    private let voiceOverlayController = VoiceOverlayController()

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: . leading) {
                    Text("Incorrect Question:")
                        .font(.headline)
                        .padding(.bottom, 5)

                    // Display incorrect questions here
                    ForEach(incorrectQuestions, id: \.self) { question in
                        Text(question.text)
                            .padding()
                            .background(Color.yellow.opacity(0.3))
                            .cornerRadius(10)
                            .padding(.bottom, 5)
                    }

                    Text("Your Speech with Highlighted Mistakes:")
                        .font(.headline)
                        .padding(.bottom, 5)

                    Text(highlightedText)
                        .padding(.bottom, 20)

                    Text("Correct Statement:")
                        .font(.headline)
                        .padding(.bottom, 5)

                    Text(correctStatement)
                        .padding()
                        .background(Color.green.opacity(0.3))
                        .cornerRadius(10)
                        .padding(.bottom, 20)
                }
                .padding(.top, 20)
            }

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
            .padding(.top, 20)

            Spacer()
        }
        .padding()
        .navigationBarTitle("Review Yourself", displayMode: .inline)
    }

    private func startRecording() {
        self.isRecording = true
        if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
            voiceOverlayController.start(on: rootViewController, textHandler: { text, final, _ in
                self.speechText = text
                if final {
                    self.stopRecording()
                    self.reviewText(speechText)
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
    }

    private func reviewText(_ text: String) {
        let prompt = """
        Please review the following text and identify any incorrect statements or words that are unrelated to the topic of data structures. Highlight those incorrect words only and provide the correct statement at the end.

        User's Speech: "\(text)"
        """
        
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "model": "gpt-4",
            "messages": [
                ["role": "system", "content": "You are a helpful assistant."],
                ["role": "user", "content": prompt]
            ],
            "max_tokens": 300,
            "temperature": 0.7
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let response = try? JSONDecoder().decode(OpenAIResponse.self, from: data),
               let text = response.choices.first?.message.content {
                self.updateReviewText(with: text)
            } else {
                print("Failed to decode response")
            }
        }
        .resume()
    }

    private func updateReviewText(with responseText: String) {
        let parts = responseText.components(separatedBy: "Correct Statement:")
        guard parts.count == 2 else { return }
        
        let highlightedPart = parts[0].trimmingCharacters(in: .whitespacesAndNewlines)
        let correctPart = parts[1].trimmingCharacters(in: .whitespacesAndNewlines)
        
        let attributedString = NSMutableAttributedString(string: highlightedPart)
        let pattern = "<<highlight>>"
        var searchRange = NSRange(location: 0, length: attributedString.length)
        
        while true {
            let foundRange = (attributedString.string as NSString).range(of: pattern, options: [], range: searchRange)
            if foundRange.location == NSNotFound {
                break
            }
            
            attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: NSRange(location: foundRange.location, length: pattern.count))
            attributedString.replaceCharacters(in: foundRange, with: "")
            searchRange = NSRange(location: foundRange.location, length: attributedString.length - foundRange.location)
        }
        
        DispatchQueue.main.async {
            self.highlightedText = AttributedString(attributedString)
            self.correctStatement = correctPart
        }
    }
}

extension AttributedString {
    init(highlight text: String) {
        var attributedString = NSMutableAttributedString(string: text)
        if !text.isEmpty {
            attributedString.addAttributes([.foregroundColor: UIColor.red], range: NSRange(location: 0, length: text.count))
        }
        self = AttributedString(attributedString)
    }
}

struct SpeechReviewView_Previews: PreviewProvider {
    static var previews: some View {
        SpeechReviewView(incorrectQuestions: [Question(text: "Sample Question", answers: ["A", "B", "C", "D"], correctAnswerIndex: 0)])
    }
}
