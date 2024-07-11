import SwiftUI
import InstantSearchVoiceOverlay

class MazeQuizViewModel: ObservableObject {
    @Published var questions: [Question] = []
    @Published var currentQuestionIndex: Int = 0
    @Published var selectedAnswerIndex: Int?
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var characterPosition = (row: 0, col: 0)
    @Published var isLoading: Bool = false
    @Published var mazeCompleted: Bool = false
    @Published var showChatbot: Bool = false
    @Published var incorrectQuestions: [Question] = [] // This will hold the incorrect questions
    @Published var speechText: String = ""
    @Published var reviewResult: String = ""

    private let apiKey = "API-KEY"
    private var topic: String

    let maze: [[Int]] = [
        [1, 0, 1, 1, 1],
        [1, 0, 1, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 1, 1, 0, 1],
        [1, 1, 1, 0, 0]
    ]

    init(topic: String) {
        self.topic = topic
        fetchQuestions(topic: topic)
    }

    func fetchQuestions(topic: String) {
        isLoading = true
        let prompt = """
        Generate 12 short quiz questions about \(topic) with 4 short multiple-choice answers each. Ensure each question has exactly one correct answer and three incorrect answers. Indicate the correct answer by appending "(correct)" to it.
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
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    print("Failed to fetch questions: \(error.localizedDescription)")
                    self.alertMessage = "Error fetching questions: \(error.localizedDescription)"
                    self.showAlert = true
                    return
                }
                
                guard let data = data else {
                    print("No data received from API")
                    self.alertMessage = "No data received from API"
                    self.showAlert = true
                    return
                }

                do {
                    print("Received response: \(String(data: data, encoding: .utf8) ?? "No response data")")
                    let response = try JSONDecoder().decode(OpenAIResponse.self, from: data)
                    self.handleResponse(response)
                } catch {
                    print("Failed to decode response: \(error.localizedDescription)")
                    print(String(data: data, encoding: .utf8) ?? "No response data")
                    self.alertMessage = "Failed to decode response: \(error.localizedDescription)"
                    self.showAlert = true
                }
            }
        }
        .resume()
    }

    private func handleResponse(_ response: OpenAIResponse?) {
        guard let text = response?.choices.first?.message.content else {
            print("No response or unexpected format")
            self.alertMessage = "No response or unexpected format"
            self.showAlert = true
            return
        }
        
        print("Received response: \(text)")
        
        let components = text.components(separatedBy: "\n\n")
        var questions: [Question] = []
        
        for component in components {
            let lines = component.split(separator: "\n")
            guard lines.count == 5 else {
                print("Invalid format: \(component)")
                continue
            }
            
            let questionText = String(lines[0])
            var answers: [String] = []
            var correctAnswerIndex: Int?
            
            for (index, line) in lines[1...4].enumerated() {
                let answer = String(line).trimmingCharacters(in: .whitespaces)
                if answer.contains("(correct)") {
                    correctAnswerIndex = index
                    answers.append(answer.replacingOccurrences(of: "(correct)", with: "").trimmingCharacters(in: .whitespaces))
                } else {
                    answers.append(answer)
                }
            }
            
            if let correctIndex = correctAnswerIndex {
                questions.append(Question(text: questionText, answers: answers, correctAnswerIndex: correctIndex))
            }
        }
        
        self.questions = questions
        self.currentQuestionIndex = 0
        
        if questions.isEmpty {
            print("No questions parsed from response")
            self.alertMessage = "No questions parsed from response"
            self.showAlert = true
        }
    }

    func checkAnswer() -> Bool {
        guard let selectedAnswerIndex = selectedAnswerIndex else { return false }
        let isCorrect = selectedAnswerIndex == questions[currentQuestionIndex].correctAnswerIndex
        alertMessage = isCorrect ? "Correct!" : "Wrong!"
        showAlert = true
        if !isCorrect {
            incorrectQuestions.append(questions[currentQuestionIndex])
        }
        return isCorrect
    }

    func goToNextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            selectedAnswerIndex = nil
        } else {
            fetchQuestions(topic: topic)  // Fetch new questions when the current set is completed
        }
    }

    func moveCharacterIfPossible(isCorrect: Bool) {
        if isCorrect {
            let nextPosition = getNextYellowPosition(from: characterPosition)
            if nextPosition != characterPosition {
                characterPosition = nextPosition
                if characterPosition == (row: 4, col: 4) {
                    mazeCompleted = true
                }
            }
        }
    }

    func getNextYellowPosition(from currentPos: (row: Int, col: Int)) -> (row: Int, col: Int) {
        for row in currentPos.row..<maze.count {
            for col in currentPos.col..<maze[row].count {
                if maze[row][col] == 0 && !(row == currentPos.row && col == currentPos.col) {
                    return (row, col)
                }
            }
        }
        return currentPos // No more yellow spots
    }
}

struct MazeView: View {
    var topic: String
    @StateObject private var viewModel: MazeQuizViewModel
    @State private var points = 0

    init(topic: String) {
        self.topic = topic
        self._viewModel = StateObject(wrappedValue: MazeQuizViewModel(topic: topic))
    }

    var body: some View {
        VStack {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Generating questions...")
                        .frame(width: 350, height: 500)
                        .offset(y: -150)
                        .font(.system(size: 16))
                } else if viewModel.questions.isEmpty {
                    Text("No questions available.")
                        .frame(width: 350, height: 500)
                        .offset(y: -150)
                        .font(.system(size: 16))
                } else if viewModel.mazeCompleted {
                    CongratsMazeView(points: points, incorrectQuestions: viewModel.incorrectQuestions)
                        .frame(width: 350, height: 500)
                        .offset(y: 100)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation {
                                    viewModel.showChatbot = true
                                }
                            }
                        }
                } else if viewModel.currentQuestionIndex < viewModel.questions.count {
                    VStack {
                        Spacer()
                        VStack {
                            TabView(selection: $viewModel.currentQuestionIndex) {
                                ForEach(0..<viewModel.questions.count, id: \.self) { index in
                                    QuestionView(question: viewModel.questions[index]) { isCorrect in
                                        if isCorrect {
                                            points += 5
                                        } else {
                                            points -= 2
                                        }
                                        viewModel.moveCharacterIfPossible(isCorrect: isCorrect)
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            viewModel.goToNextQuestion()
                                        }
                                    }
                                    .tag(index)
                                }
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                            .frame(width: 350, height: 350)
                            .padding(.top, 20)
                        }
                    }
                } else {
                    CongratsView(points: points, totalQuestions: viewModel.questions.count, incorrectQuestions: viewModel.incorrectQuestions)
                        .frame(width: 350, height: 500)
                        .offset(y: 100)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation {
                                    viewModel.showChatbot = true
                                }
                            }
                        }
                }

                MazeGridView(characterPosition: $viewModel.characterPosition)
                    .frame(width: 300, height: 300)
                    .padding(.top, 20)
            }

            Spacer()
        }
        .background(Color(UIColor.systemGray6).edgesIgnoringSafeArea(.all))
    }
}

struct MazeGridView: View {
    @Binding var characterPosition: (row: Int, col: Int)
    let maze: [[Int]] = [
        [1, 0, 1, 1, 1],
        [1, 0, 1, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 1, 1, 0, 1],
        [1, 1, 1, 0, 0]
    ]

    var body: some View {
        VStack(spacing: 2) {
            ForEach(0..<maze.count, id: \.self) { row in
                HStack(spacing: 2) {
                    ForEach(0..<maze[row].count, id: \.self) { col in
                        Rectangle()
                            .fill(self.getColorForCell(row: row, col: col))
                            .frame(width: 20, height: 20)
                    }
                }
            }
        }
    }

    private func getColorForCell(row: Int, col: Int) -> Color {
        if row == characterPosition.row && col == characterPosition.col {
            return .purple
        } else if maze[row][col] == 1 {
            return .black
        } else {
            return .yellow
        }
    }
}

struct QuestionView: View {
    let question: Question
    let onAnswerSelected: (Bool) -> Void

    @State private var selectedAnswerIndex: Int?

    var body: some View {
        VStack {
            Text(question.text)
                .font(.system(size: 16))
                .padding(.bottom, 5)
                .fixedSize(horizontal: false, vertical: true)

            ForEach(0..<question.answers.count, id: \.self) { index in
                Button(action: {
                    self.selectedAnswerIndex = index
                    let isCorrect = index == self.question.correctAnswerIndex
                    self.onAnswerSelected(isCorrect)
                }) {
                    HStack {
                        Text(self.question.answers[index])
                            .font(.system(size: 14))
                            .padding(5)
                            .background(self.selectedAnswerIndex == index ? Color.purple.opacity(0.2) : Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .foregroundColor(.black)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.horizontal, 10)
                }
                .padding(.vertical, 2)
            }

            if let selectedAnswerIndex = selectedAnswerIndex {
                Text(selectedAnswerIndex == question.correctAnswerIndex ? "Correct!" : "Wrong")
                    .font(.headline)
                    .foregroundColor(selectedAnswerIndex == question.correctAnswerIndex ? .green : .red)
                    .padding(.top, 5)
            }
        }
        .padding(.horizontal, 10)
    }
}

struct CongratsView: View {
    let points: Int
    let totalQuestions: Int
    let incorrectQuestions: [Question]

    var body: some View {
        VStack {
            if points == totalQuestions * 5 {
                Text("Congratulations!")
                    .font(.largeTitle)
                    .padding()

                Text("You have answered all questions correctly.")
                    .font(.title2)
                    .padding()
            } else {
                Text("Try Again!")
                    .font(.largeTitle)
                    .padding()

                Text("You did not answer all questions correctly.")
                    .font(.title2)
                    .padding()
            }

            Text("Your total points: \(points)")
                .font(.title3)
                .padding()

//            NavigationLink(destination: SpeechReviewView(incorrectQuestions: incorrectQuestions)) {
//                Text("Review Incorrect Questions")
//                    .font(.title)
//                    .foregroundColor(.white)
//                    .padding()
//                    .background(Color.blue)
//                    .cornerRadius(10)
//            }
            .padding(.top, 20)
        }
    }
}

struct CongratsMazeView: View {
    let points: Int
    let incorrectQuestions: [Question]

    var body: some View {
        VStack {
            Text("Congratulations!")
                .font(.largeTitle)
                .padding()

            Text("You have escaped the maze.")
                .font(.title2)
                .padding()

            Text("Your total points: \(points)")
                .font(.title3)
                .padding()

//            NavigationLink(destination: SpeechReviewView(incorrectQuestions: incorrectQuestions)) {
//                Text("Review Incorrect Questions")
//                    .font(.title)
//                    .foregroundColor(.white)
//                    .padding()
//                    .background(Color.blue)
//                    .cornerRadius(10)
//            }
            .padding(.top, 20)
        }
    }
}

struct Maze_Previews: PreviewProvider {
    static var previews: some View {
        MazeView(topic: "Operating System")
    }
}
