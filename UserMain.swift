import SwiftUI

struct UserMain: View {
    @State private var showAlert = false
    @State private var selectedDestination: Destination?
    @Environment(\.presentationMode) var presentationMode
    @State private var navigateToWelcome = false

    enum Destination {
        case currentVoting, currentSocietyVoting, currentsurvey
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.BackgroundColor.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    UlogoAndTitle
                    administratorLabel
                    
                    VStack(alignment: .leading, spacing: 20) {
                        navigationLink(for: .currentVoting, label: "Current Voting")
                        navigationLink(for: .currentSocietyVoting, label: "Current Society Voting")
                        navigationLink(for: .currentsurvey, label: "Current Survey")
                    }
                    .padding(.all)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(30)
                    .shadow(radius: 7)
                    
                    Button(action: { showAlert.toggle() }) {
                        powerButton
                    }
                    .padding()
                }.padding(.horizontal)
                .navigationBarTitle("User", displayMode: .inline)
            }
        }
        .alert(isPresented: $showAlert, content: getLogoutAlert)
        .fullScreenCover(isPresented: $navigateToWelcome, content: {
            Welcome() // Navigate to Welcome screen
        })
    }
    
    private var powerButton: some View {
        Button(action: { showAlert.toggle() }) {
            HStack {
                Image(systemName: "power")
                Text("Log out")
            }
            .foregroundColor(Color.ButtonColor)
        }
    }
    
    
    
    private var administratorLabel: some View {
        HStack {
            Image(systemName: "person.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
            Text("User")
                .fontWeight(.bold)
                .font(.title2)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.top, 10)
    }
    
    private func navigationLink(for destination: Destination, label: String) -> some View {
        NavigationLink(destination: destinationView(for: destination), tag: destination, selection: $selectedDestination) {
            CustomButton(label: label)
        }
    }
    
    private func destinationView(for destination: Destination) -> some View {
        switch destination {
        case .currentVoting:
            return AnyView(UserCastVote())
        case .currentSocietyVoting:
            return AnyView(UserCastSocietyVote())
        case .currentsurvey:
            return AnyView(Result())
        }
    }
    
    private func getLogoutAlert() -> Alert {
        Alert(
            title: Text("Log out"),
            message: Text("Are you sure you want to log out?"),
            primaryButton: .destructive(Text("Log Out")) {
                navigateToWelcome = true
            },
            secondaryButton: .cancel()
        )
    }
    private var UlogoAndTitle: some View {
        VStack {
            Image("logo")
                .clipShape(Circle())
                .scaleEffect(0.4)
                .scaledToFit()
                .frame(width: 50, height: 50)
               
            Text("BIIT Voting System")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)
        }
    }
}

struct CustomButton1: View {
    var label: String
    
    var body: some View {
        Text(label)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.ButtonColor)
            .cornerRadius(8)
    }
}

struct UserMain_Previews: PreviewProvider {
    static var previews: some View {
        UserMain()
    }
}
