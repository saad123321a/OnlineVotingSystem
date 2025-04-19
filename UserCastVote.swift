import SwiftUI

struct UserCastVote: View {
    struct Candidate3: Identifiable {
        let id = UUID()
        var name: String
        var imageName: String // New property for image name
        var votes: Int
        var isSelected: Bool
    }
    
    @State private var candidates = [
        Candidate3(name: "Saaim", imageName: "candidate_a_image", votes: 0, isSelected: false),
        Candidate3(name: "Danish", imageName: "candidate_b_image", votes: 0, isSelected: false),
        Candidate3(name: "Qasim", imageName: "candidate_c_image", votes: 0, isSelected: false)
    ]
    
    @State private var showAlert = false
    @State private var votedCandidate = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Cast Your Vote")
                    .font(.title)
                    .padding()
                
                List(candidates.indices, id: \.self) { index in
                    CandidateRow3(candidate: self.$candidates[index], candidates: self.$candidates)
                }
                
                Spacer()
                
                Button(action: {
                    self.castVote()
                }) {
                    Text("Cast Vote")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding()
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Vote Cast"), message: Text("You cast your vote to \(votedCandidate)"), dismissButton: .default(Text("OK")))
                }
            }
            .navigationBarTitle("Voting")
        }
    }
    
    private func castVote() {
        // Reset all selections
        self.candidates.indices.forEach { index in
            self.candidates[index].isSelected = false
        }
        // Select the candidate with the highest voteCount
        if let maxVotesCandidate = self.candidates.max(by: { $0.votes < $1.votes }) {
            if let selectedIndex = self.candidates.firstIndex(where: { $0.id == maxVotesCandidate.id }) {
                self.candidates[selectedIndex].isSelected = true
                self.votedCandidate = maxVotesCandidate.name
                self.showAlert = true
            }
        }
    }
}

struct CandidateRow3: View {
    @Binding var candidate: UserCastVote.Candidate3
    @Binding var candidates: [UserCastVote.Candidate3]
    
    var body: some View {
        HStack {
            // Display the candidate image
            Image("qasim")
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            
            Text(candidate.name)
            
            Spacer()
            
            Image(systemName: candidate.isSelected ? "largecircle.fill.circle" : "circle")
                .foregroundColor(.blue)
                .onTapGesture {
                    // Toggle selection
                    if !self.candidate.isSelected {
                        self.candidates.indices.forEach { index in
                            self.candidates[index].isSelected = false
                        }
                    }
                    self.candidate.isSelected.toggle()
                }
        }
        .padding()
    }
}

struct UserCastVote_Previews: PreviewProvider {
    static var previews: some View {
        UserCastVote()
    }
}
