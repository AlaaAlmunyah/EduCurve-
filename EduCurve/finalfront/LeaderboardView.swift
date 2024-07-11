import SwiftUI

struct LeaderboardView: View {
    @State private var selectedTab = "Weekly"
    @State private var scrollOffset: CGFloat = 0

    var body: some View {
        ScrollView {
            VStack {
                // Leaderboard Header
                HStack {
                    Spacer()
                    Text("Leaderboard")
                        .font(.title3)
                        .bold()
                    Spacer()
                }
                .padding(.top, 10)
                .padding(.horizontal)

                // Tab Buttons
                HStack {
                    Spacer()
                    Button(action: {
                        selectedTab = "Weekly"
                    }) {
                        Text("Weekly")
                            .fontWeight(selectedTab == "Weekly" ? .bold : .regular)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 12)
                            .background(selectedTab == "Weekly" ? Color.blue : Color.clear)
                            .foregroundColor(selectedTab == "Weekly" ? .white : Color(red: 62 / 255, green: 118 / 255, blue: 182 / 255))
                            .cornerRadius(30)
                    }
                    Spacer()
                    Button(action: {
                        selectedTab = "All Time"
                    }) {
                        Text("All Time")
                            .fontWeight(selectedTab == "All Time" ? .bold : .regular)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 12)
                            .background(selectedTab == "All Time" ? Color.blue : Color.clear)
                            .foregroundColor(selectedTab == "All Time" ? .white : .blue)
                            .cornerRadius(30)
                    }
                    Spacer()
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(10)
                .scaleEffect(0.8)
                .padding(.horizontal, 4)
                .padding(.vertical, 2)

                // Rank Info
                HStack {
                    Text("#4")
                        .font(.title)
                        .bold()
                        .padding(.horizontal, 10)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .cornerRadius(20)
                        .foregroundColor(.white)
                        .offset(x: 5)
                        .padding()
                    Text("You are doing better than 60% of other players!")
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                    Spacer()
                }
                .padding(.vertical, 5)
                .background(Color.blue.opacity(0.4))
                .cornerRadius(20)
                .padding(.horizontal, 35)
                .padding(.vertical, 15)
                .padding()
                .offset(y: -40)

                // Top 3 Players
                GeometryReader { geometry in
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: 200, height: 200)
                            .offset(x: -20, y: -70)
                        Circle()
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: 300, height: 300)
                            .offset(x: -20, y: -70)
                        Circle()
                            .fill(Color.blue.opacity(0.05))
                            .frame(width: 400, height: 400)
                            .offset(x: -20, y: -70)

                        HStack(alignment: .bottom, spacing: 20) {
                            VStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: max(60 - scrollOffset * 0.1, 60), height: max(60 - scrollOffset * 0.1, 60))
                                    .overlay(Text("2"))
                                Text("Alena Donin")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                Text("1,469 QP")
                                    .font(.caption)
                            }
                            .frame(height: 200)

                            VStack {
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: max(80 - scrollOffset * 0.1, 80), height: max(80 - scrollOffset * 0.1, 80))
                                    .overlay(
                                        Image(systemName: "crown.fill")
                                            .resizable()
                                            .frame(width: max(20 - scrollOffset * 0.05, 20), height: max(20 - scrollOffset * 0.05, 20))
                                            .foregroundColor(.white)
                                    )
                                Text("Davis Curtis")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                Text("2,569 QP")
                                    .font(.caption)
                            }
                            .frame(height: 250)

                            VStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: max(60 - scrollOffset * 0.1, 60), height: max(60 - scrollOffset * 0.1, 60))
                                    .overlay(Text("3"))
                                Text("Craig Gouse")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                Text("1,053 QP")
                                    .font(.caption)
                            }
                            .frame(height: 180)
                        }
                        .offset(x: -20, y: -180)
                        .scaleEffect(max(1 - (scrollOffset / 1000), 0.8), anchor: .top) // Scale effect for shrinking
                    }
                    .onChange(of: geometry.frame(in: .global).minY) { newValue in
                        withAnimation(.easeInOut) {
                            scrollOffset = max(newValue, 0)
                        }
                    }
                }
                .frame(height: 300)

                // Other Players
                VStack(spacing: 10) { // Add spacing between entries
                    ForEach(4..<11) { rank in
                        HStack(spacing: 15) { // Adjust spacing within the entry
                            Text("\(rank)")
                                .bold()
                                .frame(width: 30, height: 30)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(15)
                                .overlay(
                                    Text("\(rank)")
                                        .foregroundColor(.blue)
                                )
                            Circle()
                                .fill(Color.blue.opacity(0.2))
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Text("M")
                                        .foregroundColor(.blue)
                                )
                            VStack(alignment: .leading) {
                                Text("Player \(rank)")
                                    .font(.headline)
                                Text("\(500 - rank * 10) points")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 5)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.5))
                .cornerRadius(20)
                .shadow(radius: 5)

                Spacer()
            }
            .padding()
        }
        .background(Color.white)
    }
}

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView()
    }
}
