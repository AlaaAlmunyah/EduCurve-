import SwiftUI

struct AddView: View {
    @State private var navigateToReview = false
    @State private var incorrectQuestions: [Question] = []

    var body: some View {
        VStack(spacing: 20) {
            Text("Services to boost your learning journey")
                .font(.headline)
                .padding()

            NavigationLink(destination: SummarizeView()) {
                ServiceCardView(title: "Summarize", description: "Summarize your textbook, slides and other resources.")
            }

            NavigationLink(destination: FlashCardsView()) {
                ServiceCardView(title: "Flash cards", description: "Test your knowledge and see how many flashcards you can conquer!")
            }

            NavigationLink(destination: SpeechReviewView(incorrectQuestions: incorrectQuestions), isActive: $navigateToReview) {
                Button(action: {
                    // Set incorrectQuestions here based on the quiz results
                    // Example: incorrectQuestions = quizResults.incorrectQuestions
                    navigateToReview = true
                }) {
                    ServiceCardView(title: "Review yourself", description: "Use speech recognition! See if what you said was accurate.")
                }
            }
        }
        .padding()
        .navigationBarTitle("Boost", displayMode: .inline)
    }
}

struct ServiceCardView: View {
    let title: String
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)

            Text(description)
                .font(.body)
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddView()
        }
    }
}
