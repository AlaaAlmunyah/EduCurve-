import SwiftUI

struct StagesView: View {
    @Binding var selectedCourse: String?

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Start Circle
                NavigationLink(destination: CourseDetailsView(course: selectedCourse ?? "")) {
                    CircleView(title: "Start", color: Color(red: 150 / 255, green: 160 / 255, blue: 195 / 255), isStartFinish: true)
                }

                // Dashed Line
                DashedLineView()

                // Stage 1 Circle
                NavigationLink(destination: CourseDetailsView(course: selectedCourse ?? "")) {
                    CircleView(title: "Stage 1", color: Color(red: 204 / 255, green: 234 / 255, blue: 244 / 255))
                }

                // Dashed Line
                DashedLineView()

                // Stage 2 Circle
                NavigationLink(destination: CourseDetailsView(course: selectedCourse ?? "")) {
                    CircleView(title: "Stage 2", color: Color(red: 219 / 255, green: 244 / 255, blue: 219 / 255))
                }

                // Dashed Line
                DashedLineView()

                // Stage 3 Circle
                NavigationLink(destination: CourseDetailsView(course: selectedCourse ?? "")) {
                    CircleView(title: "Stage 3", color: Color(red: 255 / 255, green: 214 / 255, blue: 140 / 255))
                }

                // Dashed Line
                DashedLineView()

                // Stage 4 Circle
                NavigationLink(destination: CourseDetailsView(course: selectedCourse ?? "")) {
                    CircleView(title: "Stage 4", color: Color(red: 255 / 255, green: 193 / 255, blue: 125 / 255))
                }

                // Dashed Line
                DashedLineView()

                // Finish Circle
                NavigationLink(destination: CourseDetailsView(course: selectedCourse ?? "")) {
                    CircleView(title: "Finish", color: Color(red: 200 / 255, green: 210 / 255, blue: 245 / 255), isStartFinish: true)
                }
            }
            .padding()
        }
        .navigationBarTitle("Stages", displayMode: .inline)
    }
}

struct CircleView: View {
    var title: String
    var color: Color
    var isStartFinish: Bool = false

    var body: some View {
        ZStack {
            Circle()
                .fill(color)
                .frame(width: 100, height: 100)
            if isStartFinish {
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            } else {
                VStack {
                    Image(systemName: "lock.circle")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
                    Text(title)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
        }
        .padding(.vertical, 20)
    }
}

struct DashedLineView: View {
    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.5))
            .frame(width: 2, height: 50)
            .overlay(
                Rectangle()
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                    .foregroundColor(Color.gray.opacity(0.5))
            )
    }
}

struct StagesView_Previews: PreviewProvider {
    static var previews: some View {
        StagesView(selectedCourse: .constant("Operating System"))
    }
}
