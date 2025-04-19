import SwiftUI

// Define a model for your event
struct SSEvent: Identifiable {
    let id = UUID()
    let name: String
    var isActive: Bool // Add isActive property
}

struct Surveys: View {
    @State private var events: [SSEvent] = [
        SSEvent(name: "Lab Survey", isActive: true),
        SSEvent(name: "Students Suurvey", isActive: false),
        SSEvent(name: "University Survey", isActive: false)
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
                    .navigationBarTitle("Recent Survey")
                    
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink(destination: SurveyCreationView(), isActive: $isAddingEvent) {
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

struct Surveys_Previews: PreviewProvider {
    static var previews: some View {
        Surveys()
    }
}

