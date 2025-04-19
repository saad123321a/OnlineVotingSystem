import SwiftUI

struct PopulationSelectionView: View {
    @State private var selectedDiscipline: String?
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedSemester: String?
    @State private var selectedSections: Set<String> = []
    @State private var selectedGender: String?
    @State private var selections: [String] = []
    @State private var showAlert = false
    @State private var showSelectionDisplay = false
    @State private var selectedTenure = 0
    @State private var selectedSession = 0
    let tenureOptions = ["6 months", "1 year"]
    let sessionOptions = ["Fall", "Spring", "Summer"]

    
    @State private var startTime = Date()
    @State private var endTime = Date()

    let disciplines = ["Computer Science", "Electrical Engineering", "Mechanical Engineering"]
    let semesters = ["1st Semester", "2nd Semester", "3rd Semester", "4th Semester"]
    let sections = ["A", "B", "C", "D"]
    let genders = ["Male", "Female", "Both"]

    var body: some View {
        NavigationView {
            ZStack {
                Color.BackgroundColor.edgesIgnoringSafeArea(.all)
                
                VStack {
                    ScrollView {
                        Spacer().frame(height: 20)
                        
                        
                        GroupBox(label: Text("Set Date and Time").font(.headline)) {
                            VStack(spacing: 20) {
                                LabelDateTimePicker11(label: "Start", date: $startTime)
                                LabelDateTimePicker11(label: "End", date: $endTime)
                                
                                Picker(selection: $selectedTenure, label: Text("Tenure")) {
                                    ForEach(tenureOptions.indices, id: \.self) { index in
                                        Text(tenureOptions[index])
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                
                                Picker(selection: $selectedSession, label: Text("Session")) {
                                    ForEach(sessionOptions.indices, id: \.self) { index in
                                        Text(sessionOptions[index])
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            }
                            .padding()
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 5)
                        .padding()


                        
                        
                        GroupBox(label: Text("Select Discipline").font(.headline)) {
                            VStack(alignment: .leading, spacing: 20) {
                                ForEach(disciplines, id: \.self) { discipline in
                                    RadioButtonField(title: discipline, isSelected: selectedDiscipline == discipline) {
                                        selectedDiscipline = discipline
                                        selectedSemester = nil
                                        selectedSections.removeAll()
                                    }
                                }
                            }
                            .padding()
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 5)
                        .padding()

                        if let selectedDiscipline = selectedDiscipline {
                            GroupBox(label: Text("Select Semester").font(.headline)) {
                                VStack(alignment: .leading, spacing: 20) {
                                    ForEach(semesters, id: \.self) { semester in
                                        RadioButtonField(title: semester, isSelected: selectedSemester == semester) {
                                            selectedSemester = semester
                                            selectedSections.removeAll()
                                        }
                                    }
                                }
                                .padding()
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(radius: 5)
                            .padding()

                            if let selectedSemester = selectedSemester {
                                GroupBox(label: Text("Select Section(s)").font(.headline)) {
                                    VStack(alignment: .leading, spacing: 20) {
                                        ForEach(sections, id: \.self) { section in
                                            CheckboxField(title: section, isSelected: selectedSections.contains(section)) {
                                                if selectedSections.contains(section) {
                                                    selectedSections.remove(section)
                                                } else {
                                                    selectedSections.insert(section)
                                                }
                                            }
                                        }
                                    }
                                    .padding()
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(20)
                                .shadow(radius: 5)
                                .padding()
                            }
                        }

                        GroupBox(label: Text("Select Gender").font(.headline)) {
                            VStack(alignment: .leading, spacing: 20) {
                                ForEach(genders, id: \.self) { gender in
                                    RadioButtonField(title: gender, isSelected: selectedGender == gender) {
                                        selectedGender = gender
                                    }
                                }
                            }
                            .padding()
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 5)
                        .padding()
                        
                                            }

                    HStack {
                        Button(action: {
                            addSelection()
                            showAlert = true
                        }) {
                            Text("Add Selection")
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.white)
                                .padding(EdgeInsets(top: 22, leading: 20, bottom: 22, trailing: 20))
                                .background(Color.ButtonColor)
                                .cornerRadius(10)
                                .shadow(radius: 8)
                        }
                        .padding()

                        Spacer()

                        Button(action: {
                            showSelectionDisplay = true
                        }) {
                            Text("Show Selection")
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.white)
                                .padding(EdgeInsets(top: 22, leading: 20, bottom: 22, trailing: 20))
                                .background(Color.ButtonColor)
                                .cornerRadius(10)
                                .shadow(radius: 8)
                        }
                        .padding()
                    }
                    .padding()
                    NavigationLink(destination: SelectionDisplayView(selections: selections), isActive: $showSelectionDisplay) {
                        EmptyView()
                    }
                }
                .navigationBarTitle("Population Selection", displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    dismissView()
                }) {
                    Text("Done")
                })
                .padding()
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Population Selection Added"), message: Text("Population selection has been added successfully."), dismissButton: .default(Text("OK")))
            }
        }
    }

    func dismissView() {
        withAnimation {
            presentationMode.wrappedValue.dismiss()
        }
    }

    func addSelection() {
        guard let selectedDiscipline = selectedDiscipline,
              let selectedSemester = selectedSemester,
              let selectedGender = selectedGender else { return }

        let sectionsString = selectedSections.isEmpty ? "" : "(\(selectedSections.joined(separator: ", ")))"
        let newSelection = "\(selectedDiscipline) - \(selectedSemester) \(sectionsString) - Gender: \(selectedGender)"
        selections.append(newSelection)

        // Reset selections
        self.selectedDiscipline = nil
        self.selectedSemester = nil
        self.selectedSections = []
        self.selectedGender = nil
    }

}

struct RadioButtonField: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                    .foregroundColor(isSelected ? .blue : .gray)
                Text(title).foregroundColor(.primary)
            }
            .padding()
        }
    }
}

struct CheckboxField: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .foregroundColor(isSelected ? .blue : .gray)
                Text(title).foregroundColor(.primary).padding()
            }
        }
    }
}

struct SelectionDisplayView: View {
    var selections: [String]

    var body: some View {
        List(selections, id: \.self) { selection in
            Text(selection)
        }
        .navigationBarTitle("Population Selection")
        .background(Color.BackgroundColor)
    }
}

struct LabelDateTimePicker11: View {
    var label: String
    @Binding var date: Date

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .font(.headline)
                .foregroundColor(.secondary)
            DatePicker("", selection: $date, displayedComponents: [.hourAndMinute, .date])
                .labelsHidden()
                .datePickerStyle(DefaultDatePickerStyle())
        }
        .padding(.horizontal)
    }
}

struct FilterationScreen: View {
    var body: some View {
        Text("This is the filtration screen")
    }
}

struct PopulationSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        PopulationSelectionView()
    }
}

extension Color {
    struct theme1 {
        static let BackgroundColor = Color(red: 0.95, green: 0.95, blue: 0.95)
        static let ButtonColor = Color.blue
    }
}
struct DateTimeSelectionView: View {
    @Binding var startTime: Date
    @Binding var endTime: Date
    @Binding var selectedTenure: Int
    @Binding var selectedSession: Int
    let tenureOptions: [String]
    let sessionOptions: [String]

    var body: some View {
        GroupBox(label: Text("Set Date and Time").font(.headline)) {
            VStack(spacing: 20) {
                LabelDateTimePicker11(label: "Start", date: $startTime)
                LabelDateTimePicker11(label: "End", date: $endTime)
                
                Picker(selection: $selectedTenure, label: Text("Tenure")) {
                    ForEach(tenureOptions.indices, id: \.self) { index in
                        Text(tenureOptions[index])
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Picker(selection: $selectedSession, label: Text("Session")) {
                    ForEach(sessionOptions.indices, id: \.self) { index in
                        Text(sessionOptions[index])
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 5)
        .padding()
    }
}
