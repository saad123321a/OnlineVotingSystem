//
//  CurrentSurvey.swift
//  Biit_Voting_App
//
//  Created by Macboook on 20/04/2024.
//

import SwiftUI

struct CurrentSurvey: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: Result()) {
                    Text("Favourite Color")
                        .foregroundColor(.black)  // Set link color to white
                        .font(.headline)
                        .padding(.all) .frame(maxWidth: .infinity)
                       .background(RoundedRectangle(cornerRadius: 10).stroke(Color.red, lineWidth: 1)) // Set stroke color to red
                }
                
                    .navigationBarTitle("Surveys", displayMode: .inline)
            }
        }
    }
}

struct CurrentSurvey_Previews: PreviewProvider {
    static var previews: some View {
        CurrentSurvey()
    }
}
