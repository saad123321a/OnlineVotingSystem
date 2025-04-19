import SwiftUI

enum UserType: Int, Identifiable {
    case admin
    case voter
    
    var id: Int {
        self.rawValue
    }
}

struct Welcome: View {
    @State private var selectedUserType: UserType?
    
    var body: some View {
        ZStack {
            Color.BackgroundColor.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack {
                    Spacer().frame(height: 150)

                    // Logo and BIIT Voting System label
                    Image("logo")
                        .clipShape(Circle())
                        .scaleEffect(0.4)
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                    Text("BIIT Voting System")
                        .font(.headline)
                        .padding(.top, 15)

                    // Welcome label
                    Text("Welcome!")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 20)

                    Text("Hi there! Nice to see you.")
                        .foregroundColor(.gray)
                        .padding(.top, 10)

                    // Admin and Voter buttons with NavigationLink
                    VStack(spacing: 20) {
                        Button(action: {
                            selectedUserType = .admin
                        }) {
                            Text("Admin")
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 150, height: 50)
                                .background(Color.ButtonColor)
                                .cornerRadius(8)
                        }
                        
                        Button(action: {
                            selectedUserType = .voter
                        }) {
                            Text("Voter")
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 150, height: 50)
                                .background(Color.ButtonColor)
                                .cornerRadius(8)
                        }
                    }
                    .padding(.top, 20)

                    Spacer()
                }
                .padding()
            }
        }
        .fullScreenCover(item: $selectedUserType) { userType in
            switch userType {
            case .admin:
                LogIn(userType: .admin)
            case .voter:
                LogIn(userType: .voter)
            }
        }
        .navigationBarTitle("Welcome", displayMode: .inline)
    }
}

struct Welcome_Previews: PreviewProvider {
    static var previews: some View {
        Welcome()
    }
}
