import SwiftUI

struct AdminPage: View {
    @State private var showAlert = false
    @State private var navigateToWelcome = false // Add state variable for navigation
    @State private var selectedDestination: Destination?
    @Environment(\.presentationMode) var presentationMode

    enum Destination {
        case addVoting, addSocietyVoting, surveyCreation, results
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    VStack(spacing: 5) {
                        Spacer().frame(height: 5)
                        logoAndTitle
                        administratorLabel
                        
//                        VStack(alignment: .leading, spacing: 20) {
                            HStack( spacing: 20) {
                                addeventicon()
                                navigationLink(for: .addVoting, label: "Add Voting")
                            }.padding(30)
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.5))
                                .cornerRadius(20)
                               
                            HStack( spacing: 20) {
                                
                                CreateSocietyEventIcon()
                                navigationLink(for: .addSocietyVoting, label: "Add Society Voting")
                            }.padding(30)
                            .background(Color.white.opacity(0.5))  .cornerRadius(20)
                            HStack( spacing: 20) {
                                CreateSurveyIcon()
                                navigationLink(for: .surveyCreation, label: "Add Survey")
                            }.padding(30)
                            .background(Color.white.opacity(0.5))
                                .cornerRadius(20)
                            HStack (spacing: 20){
                                SeeResultsIcon()
                                navigationLink(for: .results, label: "Results")
                            }.padding(30)
                            .background(Color.white.opacity(0.5))
                                .cornerRadius(20)
//                        }
//                        .padding(30)
//                        .background(Color.white)
//                        .cornerRadius(30)
//                        .shadow(radius: 7)
                        
                    }
                    .padding()
                    Button(action: { showAlert.toggle() }) {
                                           powerButton
                                       }

                }
            
                .navigationBarTitle("Administrator", displayMode: .inline)
            }.background(Color.BackgroundColor)
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
                    .foregroundColor(Color.ButtonColor)
           
                Text("Log out").foregroundColor(Color.ButtonColor)
            }
        }
    }
    
    private var logoAndTitle: some View {
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
    
    private var administratorLabel: some View {
        HStack {
            PersonWithEditIcon()
                
                .clipShape(Circle())
                .scaleEffect(0.1)
                .scaledToFit()
                .frame(width: 50, height: 50)
            Text("Administrator")
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
        case .addVoting:
            return AnyView(Voting())
        case .addSocietyVoting:
            return AnyView(SocietyVoting())
        case .surveyCreation:
            return AnyView(Surveys())
        case .results:
            return AnyView(ResultsView())
        }
    }
    
    private func getLogoutAlert() -> Alert {
        Alert(
            title: Text("Log out"),
            message: Text("Are you sure you want to log out?"),
            primaryButton: .destructive(Text("Log Out")) {
                // Log out action
               // presentationMode.wrappedValue.dismiss() // Dismiss the AdminPage
                navigateToWelcome = true // Navigate to Welcome screen
            },
            secondaryButton: .cancel()
        )
    }
}

struct AdminPage_Previews: PreviewProvider {
    static var previews: some View {
        AdminPage()
    }
}

struct CustomButton: View {
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
struct addeventicon: View{
    var body: some View{
        Image(systemName: "calendar")
                   .font(.system(size: 50))
                   .foregroundColor(.ButtonColor)
                   .overlay(
                       Image(systemName: "plus.circle.fill")
                           .font(.system(size: 10))
                           .foregroundColor(.white)
                           .offset(x: 18, y: -16)
                   )
    }
    
}

struct CreateSocietyEventIcon: View {
    var body: some View {
        Image(systemName: "person.3")
            .font(.system(size: 28))
            .foregroundColor(.ButtonColor) // Change color to differentiate from the calendar icon
            .overlay(
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 4))
                    .foregroundColor(.white)
                    .offset(x:19.5, y: -7)
            )
    }
}
struct CreateSurveyIcon: View {
    var body: some View {
        ZStack {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 52))
                .foregroundColor(.ButtonColor) // Change color to differentiate from the calendar and society icons
            
            // Plus sign overlay
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 6))
                .foregroundColor(.white)
                .offset(x: 18, y: -25) // Adjust the position as needed
        }
    }
}

struct SeeResultsIcon: View {
    var body: some View {
        ZStack {
            Image(systemName: "chart.bar")
                .font(.system(size: 40))
                .foregroundColor(.ButtonColor) // Change color to differentiate from other icons
            
            // Eye icon overlay
            Image(systemName: "eye.circle.fill")
                .font(.system(size: 15))
                .foregroundColor(.ButtonColor)
                .offset(x: 20, y: -20) // Adjust the position as needed
        }
    }
}
struct PersonWithEditIcon: View {
    var body: some View {
        ZStack {
            Image(systemName: "person.crop.circle")
                .font(.system(size: 450))
                .foregroundColor(.black) // Adjust color as needed
            
//            Image(systemName: "gear")
//                .font(.system(size: 120))
//                .foregroundColor(.white) // Adjust color as needed
//                .offset(x: 10, y: 140) // Adjust position as needed
        }
    }
}
