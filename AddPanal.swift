//
//  AddPanal.swift
//  Biit_Voting_App
//
//  Created by Macboook on 26/02/2024.
//

import SwiftUI

struct AddPanal: View {
    
    @State private var votingTitle = ""
    @State private var presidentName = ""
    @State private var vicePresidentName = ""
    @State private var generalSecretaryName = ""
    var body: some View {
        VStack {
            // BIIT Voting System label
            Text("BIIT Voting System")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding([.top, .leading, .trailing], 20)
            
            // Add Voting Title
            VStack {
                LabelText(label: "Society Name")
                TextField("Enter Society Name", text: $votingTitle)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
            // Panel for President
              VotingPanel(position: "President", name: $presidentName)

              // Panel for Vice President
              VotingPanel(position: "Vice President", name: $vicePresidentName)

              // Panel for General Secretary
              VotingPanel(position: "General Secretary", name: $generalSecretaryName)
            Button(action: {
                            // Add your submit logic here
                            print("Submit Button Clicked")
                        }) {
                            Text("Submit")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.red)
                                .cornerRadius(8)
                        }
                        .padding(.top, 20)

                        Spacer()
        }
    }
    struct VotingPanel: View {
        var position: String
        @Binding var name: String

        var body: some View {
            VStack {
                Text("\(position) ")
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                    .padding(.top, 15)

                TextField("Enter \(position) name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
        }
    
    }
}

struct AddPanal_Previews: PreviewProvider {
    static var previews: some View {
        AddPanal()
    }
}
