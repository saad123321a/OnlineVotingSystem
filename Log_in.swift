import SwiftUI
class UserManager: ObservableObject {
    @Published var currentUserID: Int? {
        didSet {
            print("User ID set to: \(currentUserID ?? -1)")
        }
    }
    
    static let shared = UserManager()
    
    private init() {}
}
import SwiftUI

struct LogIn: View {
    @State private var username = ""
    @State private var password = ""
    @State private var isLogged: Bool = false
    @State private var loginError: String?
    @EnvironmentObject var userManager: UserManager
    @Environment(\.presentationMode) var presentationMode
    let userType: UserType
    
    var body: some View {
        NavigationView {
            ScrollView {
                Spacer()
                VStack {
                    Spacer().frame(height: 120)
                    
                    Image("logo")
                        .clipShape(Circle())
                        .scaleEffect(0.4)
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                    
                    Text("BIIT Voting System")
                        .font(.headline)
                        .padding(.top, 15)
                    
                    VStack {
                        Text("Sign In")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.top, 20)
                        
                        TextField("Username", text: $username)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        
                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        
                    }
                    .padding(.all, 30)
                    .background(Color.white)
                    .cornerRadius(30)
                    .shadow(color: Color.black.opacity(0.5), radius: 10, x: 2, y: 15)
                    .padding()
                    
                    Button(action: {
                        login()
                    }) {
                        Text("Log In")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 200, height: 50)
                            .background(Color.ButtonColor)
                            .cornerRadius(8)
                    }
                    .padding(.top, 20)
                    
                    if let loginError = loginError {
                        Text(loginError)
                            .foregroundColor(.red)
                            .padding(.top, 10)
                    }
                    
                    Spacer()
                }
                .background(Color.BackgroundColor)
                .padding()
                .navigationBarHidden(true)
                .onAppear {
                    username = ""
                    password = ""
                }
            }
            .background(Color.BackgroundColor)
        }
        .fullScreenCover(isPresented: $isLogged) {
            switch userType {
            case .admin:
                AdminPage()
            case .voter:
                UserMain()
            }
        }
    }
    
    private func login() {
        switch userType {
        case .admin:
            NetworkManager.shared.loginAdmin(name: username, password: password) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        isLogged = true
                    case .failure(let error):
                        loginError = error.localizedDescription
                    }
                }
            }
        case .voter:
            NetworkManager.shared.loginUser(username: username, password: password) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        isLogged = true
                    case .failure(let error):
                        loginError = error.localizedDescription
                    }
                }
            }
        }
    }
}

struct LogIn_Previews: PreviewProvider {
    static var previews: some View {
        LogIn(userType: .admin)
            .environmentObject(UserManager.shared)
    }
}
