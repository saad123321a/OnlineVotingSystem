import SwiftUI

struct ResultsView: View {
    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .leading, spacing: 20) {
                    Spacer()

                    NavigationLink(destination: VotingResultsView()) {
                        Text("Voting Results")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding(.all)
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.ButtonColor))
                    }

                    NavigationLink(destination: SocietyResultsView()) {
                        Text("Society Results")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding(.all)
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.ButtonColor))
                    }

                    NavigationLink(destination: SurveyResultsView()) {
                        Text("Survey Results")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding(.all)
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.ButtonColor))
                    }

                    Spacer()
                }
                .padding()
            .navigationBarTitle("Results", displayMode: .inline)
            }.background(Color.BackgroundColor)
        }
    }
}

struct VotingResultsView: View {
    var body: some View {
        ZStack {
            VStack {
                Text("")
                    .navigationBarTitle("Voting Results", displayMode: .inline)
                PIGraph()
                    .frame(height: 300) // Adjust the height as needed
            }
        }.background(Color.BackgroundColor)
    }
}

struct SocietyResultsView: View {
    var body: some View {
        ZStack {
            VStack {
                Text("")
                    .navigationBarTitle("Society Results", displayMode: .inline)
                PIGraph()
                    .frame(height: 300) // Adjust the height as needed
            }
        }.background(Color.BackgroundColor)
    }
}

struct SurveyResultsView: View {
            var body: some View {
            
                ZStack{
                VStack {
                    Text("Survey Results Content Goes Here")
                        .navigationBarTitle("Survey Results", displayMode: .inline)
                    PIGraph()
                        .frame(height: 300) // Adjust the height as needed
                }}.background(Color.BackgroundColor)
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView()
    }
}
