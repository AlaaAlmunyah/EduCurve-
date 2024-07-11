import SwiftUI

struct CourseDetailsView: View {
    var course: String

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                NavigationLink(destination: MazeView(topic: course)) {
                    CourseDetailCard(
                        title: "Escape The Maze",
                        subtitle: "Shapes",
                        description: "Navigate through the maze and find the exit!",
                        imageName: "maze",
                        backgroundColor: Color.cyan)
                }
                NavigationLink(destination: SpinWheel()) {
                    CourseDetailCard(
                        title: "Spin The Wheel",
                        subtitle: "SPIN UNTIL YOU WIN",
                        description: "Spin the wheel and test yourself in the chapters!",
                        imageName: "spin",
                        backgroundColor: Color(red: 177 / 255, green: 216 / 255, blue: 183 / 255))
                }
                NavigationLink(destination: TimerView()) {
                    CourseDetailCard(
                        title: "Hot Potato",
                        subtitle: "Shapes",
                        description: "Pass the potato before the timer runs out!",
                        imageName: "timer",
                        backgroundColor: Color(red: 127 / 255, green: 127 / 255, blue: 245 / 255))
                }
                NavigationLink(destination: MatchCards()) {
                    CourseDetailCard(
                        title: "Matching Cards",
                        subtitle: "Shapes",
                        description: "Match the cards to clear the board!",
                        imageName: "matching",
                        backgroundColor: Color.yellow.opacity(0.4))
                }
            }
            .padding()
        }
        .navigationBarTitle("Choose A Game", displayMode: .inline)
    }
}

struct CourseDetailCard: View {
    var title: String
    var subtitle: String
    var description: String
    var imageName: String
    var backgroundColor: Color

    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(backgroundColor)
            .frame(height: 200)
            .overlay(
                HStack {
                    Image(imageName)
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .padding()

                    VStack(alignment: .leading) {
                        Text(title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text(subtitle)
                            .foregroundColor(.white.opacity(0.7))
                        Text(description)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    Spacer()
                }
                .padding()
            )
            .shadow(radius: 5)
    }
}


#Preview {
    CourseDetailsView(course: "Operating System")
}
