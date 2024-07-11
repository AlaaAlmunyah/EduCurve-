import SwiftUI

struct ProfileView: View {
    @State private var isProfileHeaderSmall = false
    
    var body: some View {
        ZStack {
            // Background color
            Color(red: 62 / 255, green: 118 / 255, blue: 182 / 255)
                .edgesIgnoringSafeArea(.all)
            
            // Content
            VStack {
                Spacer()
                
                // Profile Header
                Group {
                    VStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: isProfileHeaderSmall ? 50 : 100, height: isProfileHeaderSmall ? 50 : 100)
                            .overlay(
                                Image("user")
                                    .resizable()
                                    .frame(width: isProfileHeaderSmall ? 40 : 80, height: isProfileHeaderSmall ? 40 : 80)
                            )
                            .offset(y:20)
                            .shadow(radius: 5)
                        
                        Text("Sara Ali Alharbi")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 62 / 255, green: 118 / 255, blue: 182 / 255))
                            .offset(y: isProfileHeaderSmall ? 25 : 30)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(red: 62 / 255, green: 118 / 255, blue: 182 / 255))
                                .frame(height: isProfileHeaderSmall ? 50 : 60)
                                
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Artificial Intelligence")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    
                                    Text("FIRST SEMESTER, 2024")
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.7))
                                }
                                Rectangle()
                                    .frame(width: 1, height: isProfileHeaderSmall ? 15 : 30) // Adjust height as needed
                                    .foregroundColor(.white.opacity(0.3)) // Adjust color as needed
                                VStack {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.white)
                                    Text("590 POINTS")
                                        .font(.headline)
                                        .foregroundColor(.white.opacity(0.7))
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.top, 16)
                        .shadow(radius: 5)
                        .scaleEffect(0.8) // Adjust to a smaller value
                        .padding(.horizontal, 4) // Adjust padding for the HStack
                        .padding(.vertical, 2) // Adjust padding for the HStack

                    }
                    .scaleEffect(isProfileHeaderSmall ? 0.8 : 1.0)
                    .animation(.easeInOut, value: isProfileHeaderSmall)
                }
                
                CourseProgressView(isProfileHeaderSmall: $isProfileHeaderSmall)
                    .padding(.top, -15)
                
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 40)
                    .fill(Color.white)
                    .frame(height: 700)
                    .offset(y: isProfileHeaderSmall ? 50 : 80)
                    .animation(.easeInOut, value: isProfileHeaderSmall)
            )
            .padding()
        }
    }
}

struct CourseProgressView: View {
    @State private var showCoursesDropdown = false
    @Binding var isProfileHeaderSmall: Bool

    var body: some View {
        VStack(spacing: 20) {
            // Dropdown Menu
            HStack {
                Text("Python")
                    .font(.headline)
                Spacer()
                Image(systemName: "chevron.down")
                    .scaleEffect(0.8) // Make chevron smaller
            }
            .padding()
            .background(Color.white)
            .cornerRadius(40)
            .frame(height: 35) // Adjust height as needed
            .padding(.horizontal)
            .scaleEffect(0.8) // Adjust to a smaller value
            .padding(.horizontal, 50) // Adjust padding for the HStack
            .padding(.vertical, 2) // Adjust padding for the HStack
            .offset(x:70)
            .onTapGesture {
                withAnimation {
                    showCoursesDropdown.toggle()
                    isProfileHeaderSmall.toggle()
                }
            }

            if showCoursesDropdown {
                VStack(alignment: .leading) {
                    Text("Data Structure")
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                    Divider()
                    Text("Calculus")
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                    Divider()
                    Text("Introduction to Programming")
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                }
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding(.horizontal)
            }

            // Progress Info
            Text("You have played a total")
                .font(.title3)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.bottom, -20) // Adjust the negative padding as needed

            Text("4 Stage this course!")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 127 / 255, green: 127 / 255, blue: 245 / 255))
                .multilineTextAlignment(.center)


            // Circular Progress Bar
            ZStack {
                Circle()
                    .stroke(lineWidth: 10)
                    .opacity(0.3)
                    .foregroundColor(Color(red: 127 / 255, green: 127 / 255, blue: 245 / 255))

                Circle()
                    .trim(from: 0.0, to: 0.2)
                    .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                    .foregroundColor(Color(red: 127 / 255, green: 127 / 255, blue: 245 / 255))
                    .rotationEffect(Angle(degrees: 270.0))
                    .animation(.linear, value: 1)

                VStack {
                    Text("4/20")
                        .font(.subheadline)
                        .fontWeight(.bold)
                    Text("quiz played")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .frame(width: 100, height: 100)
            Spacer()

            // Button
            Button(action: {
                // Add action here
            }) {
                HStack {
                    Text("Keep playing")
                        .font(.subheadline)  // Adjust font size here
                    Image(systemName: "star.fill")
                        .scaleEffect(0.6) // Adjust the size of the star icon
                }
                .padding(.horizontal, 7)  // Adjust horizontal padding
                .padding(.vertical, 5)  // Adjust vertical padding
                .background(Color(red: 127 / 255, green: 127 / 255, blue: 245 / 255))
                .foregroundColor(.white)
                .cornerRadius(60)
                .offset(y:-20)           
            }

            Spacer()
        }
        .padding()
        .background(Color.blue.opacity(0.1)) // Light background color
        .cornerRadius(20)
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        
        .scaleEffect(0.9) // Adjust to a smaller value
        .padding(.horizontal, 4) // Adjust padding for the HStack
        .padding(.vertical, 2) // Adjust padding for the HStack


    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
