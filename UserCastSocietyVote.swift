import SwiftUI

struct Society: Identifiable {
    let id = UUID()
    let name: String
    let panels: [Panel3]
}

struct Panel3: Identifiable {
    let id = UUID()
    let title: String
    let president: Person
    let vp: Person
    let assistant: Person
    var isSelected: Bool // New property to track selection
}

struct Person {
    let name: String
    let designation: String // New property for designation
    let imageName: String
}

struct UserCastSocietyVote: View {
    let societies = [
        Society(name: "Gala Society", panels: [
            Panel3(title: "Panel 1", president: Person(name: "Saad", designation: "President", imageName: "president_image_1"), vp: Person(name: "Saaim", designation: "Vice President", imageName: "vp_image_1"), assistant: Person(name: "Danish", designation: "Assistant", imageName: "assistant_image_1"), isSelected: false),
            Panel3(title: "Panel 2", president: Person(name: "Saad Abbasi", designation: "President", imageName: "president_image_2"), vp: Person(name: "Saaim Kan", designation: "Vice President", imageName: "vp_image_2"), assistant: Person(name: "Danish Khan", designation: "Assistant", imageName: "assistant_image_2"), isSelected: false)
        ]),
        Society(name: "Adventure Society", panels: [
            Panel3(title: "Panel 1", president: Person(name: "Saad", designation: "President", imageName: "president_image_3"), vp: Person(name: "Anas", designation: "Vice President", imageName: "vp_image_3"), assistant: Person(name: "Sufyan", designation: "Assistant", imageName: "assistant_image_3"), isSelected: false),
            Panel3(title: "Panel 2", president: Person(name: "Hammad", designation: "President", imageName: "president_image_4"), vp: Person(name: "Qasim", designation: "Vice President", imageName: "vp_image_4"), assistant: Person(name: "Hassan", designation: "Assistant", imageName: "assistant_image_4"), isSelected: false)
        ])
    ]

    var body: some View {
        NavigationView {
            List(societies) { society in
                NavigationLink(destination: SocietyView(society: society)) {
                    Text(society.name)
                }
            }
            .navigationTitle("Societies")
        }
    }
}

struct SocietyView: View {
    @State private var selectedPanelIndex: Int = -1 // State to track the selected panel index
    @State private var showAlert: Bool = false // State to control the display of the alert
    let society: Society

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(society.panels.indices) { index in
                    VStack(alignment: .leading) {
                        HStack {
                            RadioButton(selectedIndex: $selectedPanelIndex, index: index) // Radio button
                            Text(society.panels[index].title)
                                .font(.headline)
                                .padding(.bottom, 5)
                        }
                        
                        PersonRow(person: society.panels[index].president)
                        PersonRow(person: society.panels[index].vp)
                        PersonRow(person: society.panels[index].assistant)
                    }
                    .padding()
                    .background(society.panels[index].isSelected ? Color.blue.opacity(0.2) : Color(UIColor.systemGray6))
                    .cornerRadius(10)
                    .onTapGesture {
                        selectedPanelIndex = index
                    }
                }
            }
            .padding() // Add padding here for equal spacing between panels
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle(society.name)
        .navigationBarItems(trailing: Button(action: {
            showAlert = true // Show the alert when Cast Vote button is tapped
        }) {
            Text("Cast Vote")
        })
        .alert(isPresented: $showAlert) {
            // Construct the alert message based on the selected panel
            let selectedPanel = selectedPanelIndex >= 0 && selectedPanelIndex < society.panels.count ? society.panels[selectedPanelIndex] : nil
            let message = selectedPanel != nil ? "You cast your vote to \(selectedPanel!.title)" : "Please select a panel before casting your vote"
            return Alert(title: Text("Vote Cast"), message: Text(message), dismissButton: .default(Text("OK")))
        }
    }
}




struct RadioButton: View {
    @Binding var selectedIndex: Int
    let index: Int

    var body: some View {
        Button(action: {
            selectedIndex = index
        }) {
            Image(systemName: selectedIndex == index ? "largecircle.fill.circle" : "circle")
                .foregroundColor(.blue)
        }
    }
}

struct PersonRow: View {
    let person: Person

    var body: some View {
        HStack {
            Image(systemName: "person.fill") // Use system image name
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())

            VStack(alignment: .leading) {
                Text("\(person.designation): \(person.name)")
                    .font(.headline)
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        UserCastSocietyVote()
    }
}
