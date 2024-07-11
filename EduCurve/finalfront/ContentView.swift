import SwiftUI
import Charts

struct ContentView: View {
    init() {
        UITabBar.appearance().backgroundColor = UIColor.white
    }
    
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
            
            NavigationView {
                           AddView()
                       }
                       .tabItem {
                           Image(systemName: "plus.circle.fill")
                           Text("Boost")
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
        .background(Color.white.edgesIgnoringSafeArea(.all)) // Ensure the TabView has a white background
    }
}

struct CustomNavigationBar: View {
    var body: some View {
        Spacer()
        Spacer()
        
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 62 / 255, green: 118 / 255, blue: 182 / 255))
                .frame(height: 70)
                .shadow(radius: 5)
            
            HStack {
                Circle()
                    .fill(Color.white)
                    .frame(width:40, height: 40)
                    .padding(.horizontal)
                    .overlay(
                Image("user")
                    .resizable()
                    .frame(width: 35, height: 35)
                    .clipShape(Circle())
                )
                
                VStack(alignment: .leading) {
                    Text("Sara Ali Alharbi")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("POINTS: 1000")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                }
                Spacer()
                HStack(spacing: 16) {
                    Image(systemName: "line.horizontal.3")
                        .foregroundColor(.white)
                    Image(systemName: "bell")
                        .foregroundColor(.white)
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
                }
                .padding(.trailing, 10)
            }
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
    
}


struct HomeView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    CustomNavigationBar() // Add this line to include the custom navigation bar

                    // Existing content goes here
                    // Courses
                    Spacer()
                    Spacer()

                    VStack(alignment: .leading, spacing: 4) {
                        
                        HStack {
                            Text("Courses")
                                .font(.system(size: 18))
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                            NavigationLink(destination: DashboardView()) {
                                   Text("See All")
                                       .font(.subheadline)
                                       .foregroundColor(.gray)
                               }
                        }
                        .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                CustomCourseCard(courseName: "Data Structure", color: Color.purple)
                                CustomCourseCard(courseName: "Calculus", color: Color.green)
                                CustomCourseCard(courseName: "Introduction to Programming", color: Color.blue)
                            }
                            .padding(.horizontal)
                        }
                        
                        Text("One step at a time, you'll get there!")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    }
                    .padding()
                    // Performance Chart
                    PerformanceChartView()
                        .padding()
                        .padding()


                    // Tasks
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Tasks")
                            .font(.system(size: 18))
                            .font(.title2)
                            .padding(.horizontal,3)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        TaskRow(course: "Calculus", dueDate: "1 Nov", stage: "Stage 4", status: "Completed")
                        TaskRow(course: "Operating System", dueDate: "12 Nov", stage: "Stage 4", status: "Upcoming")
                        TaskRow(course: "Data Structure", dueDate: "13 Nov", stage: "Stage 5", status: "Upcoming")
                    }
                    .padding()
                    .padding(.horizontal)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
        }
        .scaleEffect(0.98) // Adjust to a smaller value
        .padding(.horizontal, 4) // Adjust padding for the HStack
        .padding(.vertical, 2) // Adjust padding for the HStack
    }
}


struct CustomCourseCard: View {
    var courseName: String
    var color: Color

    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 15, height: 15)
            Text(courseName)
                .font(.headline)
                .fontWeight(.bold)
            Spacer()
            Image(systemName: "ellipsis")
                .foregroundColor(.gray)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(30)
        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}

struct PerformanceChartView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Performance")
                .font(.system(size: 18))
                .font(.title2)
                .padding(.horizontal,3)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Chart {
                ForEach(performanceData, id: \.self) { series in
                    ForEach(series.data, id: \.self) { point in
                        LineMark(
                            x: .value("Stage", point.stage),
                            y: .value("Points", point.points)
                        )
                        .foregroundStyle(by: .value("Series", series.name))
                    }
                }
            }
            .frame(height: 250)
            .padding(.horizontal)
        }
    }
}

struct PerformanceData: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var data: [DataPoint]
    
    struct DataPoint: Identifiable, Hashable {
        var id = UUID()
        var stage: String
        var points: Int
    }
    
    static let example = PerformanceData(
        name: "Data Structure",
        data: [
            DataPoint(stage: "Stage 1", points: 10),
            DataPoint(stage: "Stage 2", points: 20),
            DataPoint(stage: "Stage 3", points: 30),
            DataPoint(stage: "Stage 4", points: 40),
            DataPoint(stage: "Stage 5", points: 50)
        ]
    )
}

let performanceData = [PerformanceData.example]

struct TaskRow: View {
    var course: String
    var dueDate: String
    var stage: String
    var status: String

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(course)
                    .font(.headline)
                Text(stage)
                    .font(.subheadline)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(dueDate)
                    .font(.subheadline)
                StatusView(status: status)
            }
        }
        .padding(.vertical, 4)
    }
}

struct StatusView: View {
    var status: String

    var body: some View {
        Text(status)
            .padding(5)
            .background(status == "Completed" ? Color.blue.opacity(0.2) : Color.red.opacity(0.2))
            .cornerRadius(5)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
