import SwiftUI
import SwiftUICharts

struct Candidate1 {
    var name: String
    var photo: String // Image name or URL
    var votes: Int
}

struct VotingEventResult: View {
    let candidates = [
        Candidate1(name: "Candidate A", photo: "candidate_a_photo", votes: 150),
        Candidate1(name: "Candidate B", photo: "candidate_b_photo", votes: 200),
        Candidate1(name: "Candidate C", photo: "candidate_c_photo", votes: 10),
        Candidate1(name: "Candidate D", photo: "candidate_d_photo", votes: 250)
    ]
    
    var body: some View {
        VStack {
            Text("Voting Results").font(.title)
            
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(candidates, id: \.name) { candidate in
                        CandidateRow1(candidate: candidate)
                    }
                }
            }
            
            PieChartView(data: candidates.map { Double($0.votes) }, title: "Voting Results", legend: "Candidates")
                .padding()
            
            VStack(spacing: 20) {
                ForEach(candidates.indices, id: \.self) { index in
                    HStack {
                        Text("\(candidates[index].name):")
                        Spacer()
                        Text("\(candidates[index].votes) votes")
                    }
                }
            }
            .padding()
        }
    }
}

struct CandidateRow1: View {
    let candidate: Candidate1
    
    var body: some View {
        HStack {
            Image(systemName: "person.crop.circle")
                .resizable()
                .frame(width: 50, height: 50)
                .padding(.trailing, 10)
            
            VStack(alignment: .leading) {
                Text(candidate.name)
                    .font(.headline)
                
                Text("\(candidate.votes) votes")
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(.vertical, 10)
        .padding(.horizontal)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

struct VotingEventResult_Previews: PreviewProvider {
    static var previews: some View {
        VotingEventResult()
    }
}
