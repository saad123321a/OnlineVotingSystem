import SwiftUI

// Define a model for your event
struct SEvent: Identifiable {
    let id = UUID()
    let name: String
    var isActive: Bool // Add isActive property
}

struct SocietyVoting: View {
    @State private var events: [SEvent] = [
        SEvent(name: "Cultural Society", isActive: true),
        SEvent(name: "Adventure Society", isActive: false),
        SEvent(name: "Sports Society", isActive: false)
    ]
    
    @State private var isAddingEvent = false // Track if Add button is tapped
    
    var body: some View {
        NavigationView {
           ZStack {
               Color.BackgroundColor.ignoresSafeArea(.all)
                ScrollView {
                    
                    VStack(spacing: 20) {
                        Spacer()
                        
                        ForEach(events.indices, id: \.self) { index in
                            Button(action: {
                                toggleEvent(index)
                            }) {
                                Text(events[index].name)
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(events[index].isActive ? Color.ButtonColor : Color.gray)
                                    )
                            }
                        }
                    }
                    .padding()
                    .navigationBarTitle("Recent Event")
                    
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink(destination: AddSocietyVoting(), isActive: $isAddingEvent) {
                                Button(action: {
                                    isAddingEvent.toggle()
                                }) {
                                    HStack {
                                        Text("Add")
                                        Image(systemName: "plus.circle.fill")
                                    }
                                }
                            }
                        }
                }
                }
            }
        }
    }
    
    // Function to toggle the active status of an event
    private func toggleEvent(_ index: Int) {
        events[index].isActive.toggle()
    }
}

struct SocietyVoting_Previews: PreviewProvider {
    static var previews: some View {
        SocietyVoting()
    }
}

