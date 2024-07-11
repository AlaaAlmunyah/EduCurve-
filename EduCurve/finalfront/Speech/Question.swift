import Foundation

struct Question: Identifiable, Hashable {
    let id = UUID()
    let text: String
    let answers: [String]
    let correctAnswerIndex: Int
}
