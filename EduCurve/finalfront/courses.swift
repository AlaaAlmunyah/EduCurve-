import SwiftUI

struct CoursesView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            DashboardView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Courses")
                }

            AddView()
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("Add")
                }

            LeaderboardView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Leaderboard")
                }

            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
    }
}

struct DashboardView: View {
    @State private var selectedCourse: String? = nil

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    // Profile Header
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(red: 62 / 255, green: 118 / 255, blue: 182 / 255))
                            .frame(height: 200)

                        VStack {
                            Circle()
                                .fill(Color.white)
                                .shadow(radius: 10)
                                .frame(width: 80, height: 80)
                                .overlay(
                                    Image("user")
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                )
                            Text("Sara Ali Alharbi")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Text("POINTS: 1000")
                                .font(.subheadline)
                                .foregroundColor(.white)
                        }
                    }
                    .shadow(radius: 5)
                    .padding()

                    // Courses Info
                    VStack {
                        Text("4 Courses you're enrolled in")
                            .font(.system(size: 15))
                            .fontWeight(.bold)
                            .font(.headline)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(Color.white)
                            .cornerRadius(40)
                            .shadow(radius: 5)
                            .padding(.horizontal)
                            .padding(.top, -40)
                    }

                    // In Progress Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("In progress")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)

                        NavigationLink(destination: StagesView(selectedCourse: $selectedCourse), tag: "Operating System", selection: $selectedCourse) {
                            EmptyView()
                        }
                        NavigationLink(destination: StagesView(selectedCourse: $selectedCourse), tag: "Data Structure", selection: $selectedCourse) {
                            EmptyView()
                        }
                        NavigationLink(destination: StagesView(selectedCourse: $selectedCourse), tag: "Calculus", selection: $selectedCourse) {
                            EmptyView()
                        }
                        NavigationLink(destination: StagesView(selectedCourse: $selectedCourse), tag: "Python", selection: $selectedCourse) {
                            EmptyView()
                        }

                        CourseCard(
                            icon: "laptopcomputer",
                            title: "Operating System",
                            stage: "Stage: 4",
                            progress: 0.4,
                            isSelected: selectedCourse == "Operating System",
                            onSelect: { selectedCourse = "Operating System" }
                        )
                        CourseCard(
                            icon: "cylinder",
                            title: "Data Structure",
                            stage: "Stage: 5",
                            progress: 0.5,
                            isSelected: selectedCourse == "Data Structure",
                            onSelect: { selectedCourse = "Data Structure" }
                        )
                        CourseCard(
                            icon: "function",
                            title: "Calculus",
                            stage: "Stage: 5",
                            progress: 0.5,
                            isSelected: selectedCourse == "Calculus",
                            onSelect: { selectedCourse = "Calculus" }
                        )
                        CourseCard(
                            icon: "chevron.left.slash.chevron.right",
                            title: "Python",
                            stage: "Stage: 6",
                            progress: 0.6,
                            isSelected: selectedCourse == "Python",
                            onSelect: { selectedCourse = "Python" }
                        )
                    }
                    .padding(.top)

                    // Finished Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Finished")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)

                        Text("No course is finished yet...")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    }
                    .padding(.horizontal)
                    .offset(x: -80, y: -50)
                    .padding(.top)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct CourseCard: View {
    var icon: String
    var title: String
    var stage: String
    var progress: Double
    var isSelected: Bool
    var onSelect: () -> Void

    var body: some View {
        HStack {
            Image(systemName: icon)
                .resizable()
                .frame(width: 40, height: 40)
                .padding()
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text(stage)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                ProgressView(value: progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
            }
            .padding()
        }
        .background(isSelected ? Color.blue.opacity(0.1) : Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
        .padding(.horizontal, 40)
        .offset(y: -50)
        .onTapGesture {
            onSelect()
        }
    }
}

struct CoursesView_Previews: PreviewProvider {
    static var previews: some View {
        CoursesView()
    }
}
