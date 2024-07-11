import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack {
            Spacer()
            
            Image("logo") 
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding(.bottom, 40)
            
            Text("Welcome back")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 5)
            
            Text("Continue with Blackboard or enter your details.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
                .padding(.bottom, 20)
            
            Button(action: {
                // Blackboard login action
            }) {
                HStack {
                    Image("blackboard") // Replace with your Blackboard logo image name
                        .resizable()
                        .frame(width: 40, height: 40)
                    Text("Log in with Blackboard")
                        .foregroundColor(.black)
                        .font(.headline)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 20)
            
            HStack {
                Divider()
                    .frame(height: 1)
                    .background(Color.gray)
                Text("Or")
                    .foregroundColor(.gray)
                    .font(.subheadline)
                Divider()
                    .frame(height: 1)
                    .background(Color.gray)
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 10)
            
            VStack(alignment: .leading) {
                Text("Username")
                    .font(.headline)
                    .foregroundColor(.black)
                
                TextField("Enter your username", text: $username)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                
                Text("Password")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.top, 20)
                
                SecureField("Enter your password", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                
                HStack {
                    Spacer()
                    Button(action: {
                        // Forgot password action
                    }) {
                        Text("Forgot password")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.top, 10)
            }
            .padding(.horizontal, 30)
            
            Spacer()
            
            Button(action: {
                // Login action
            }) {
                Text("Log in")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.black)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 30)
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
