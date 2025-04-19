import SwiftUI

struct AddVotingView: View {
    @State private var selectedImage: UIImage? = nil
    @State private var isShowingImagePicker = false
    @State var showSheet: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @State private var votingTitle = ""
    @State private var candidates: [String] = [""]
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var selectedDiscipline: Set<String> = []
    @State private var selectedSemester: Set<String> = []
    @State private var selectedSection: Set<String> = []
    @FocusState private var isTextFieldFocused: Bool
    @StateObject private var viewModel = VotingEventViewModel()
    @State private var showEventList = false
    let disciplines = ["Computer Science", "Electrical Engineering", "Mechanical Engineering", "Electrical Engineering"]
    let semesters = ["1st Semester", "2nd Semester", "3rd Semester", "4th Semester"]
    let sections = ["A", "B", "C"]
    @State private var selectedImages: [UIImage?] = [nil]
    @State private var selectedIndex = 0

    var body: some View {
        NavigationStack {
            ZStack {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        showEventList = false
                        isTextFieldFocused = false
                    }
                VStack {
                    Text("BIIT Voting System")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 20)
                    VStack {
                        LabelText(label: "Voting Title")
                        TextField("Search Event", text: $viewModel.selectedEventTitle)
                            .focused($isTextFieldFocused)
                            .onChange(of: viewModel.selectedEventTitle) { newValue in
                                viewModel.filterVotingEvents(searchText: newValue)
                                if !newValue.isEmpty {
                                    showEventList = true // Show list only if the text field is not empty
                                }
                            }
                            .onSubmit {
                                isTextFieldFocused = false // Lose focus when submitting
                            }
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)

                        // List of filtered events
                        if showEventList && !viewModel.filteredVotingEvents.isEmpty {
                            List(viewModel.filteredVotingEvents) { event in
                                if let title = event.title {
                                    Text(title)
                                        .onTapGesture {
                                            viewModel.selectedEventTitle = title
                                            viewModel.selectedEventID = event.id
                                            showEventList = false
                                            isTextFieldFocused = false // Optionally lose focus
                                        }
                                }
                            }
                            .frame(maxHeight: 200) // Limit the height of the list
                        }
                    }
                    .padding()

                    ScrollView {
                        AddCandidateView(candidates: $candidates, selectedImages: $selectedImages)
                            .environmentObject(viewModel)
                    }
                    .background(Color.BackgroundColor.ignoresSafeArea(.all))

                    HStack {
                        Spacer()
                        Button {
                            showSheet.toggle()
                        } label: {
                            Image(systemName: "slider.horizontal.3")
                                .foregroundColor(Color.ButtonColor)
                                .font(.title)
                                .padding(20)
                                .background(Color.white.cornerRadius(10))
                        }
                        .sheet(isPresented: $showSheet) {
                            PopulationSelectionView()
                        }

                        Button {
                            // Submit action
                        } label: {
                            Text("Submit")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.ButtonColor)
                        .cornerRadius(8)
                        .sheet(isPresented: $showSheet) {
                            Filteration()
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color.BackgroundColor)
        }
    }
}
import SwiftUI

struct AddCandidateView: View {
    @Binding var candidates: [String]
    @Binding var selectedImages: [UIImage?]
    @State private var selectedImage: UIImage? = nil
    @State private var isShowingImagePicker = false
    @State private var selectedIndex = 0
    @State private var newCandidates: String = ""
    @FocusState private var isTextFieldFocused: Bool
    @State private var showUserList: Bool = false
    @State private var searchText: String = ""
    @EnvironmentObject var viewModel: VotingEventViewModel

    var body: some View {
        VStack {
            TextField("Enter candidates separated by commas", text: $newCandidates)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding(.bottom)

            Button(action: {
                self.addMultipleCandidates()
            }) {
                HStack {
                    Image(systemName: "plus")
                        .foregroundColor(Color.ButtonColor)
                    Text("Add Candidates")
                        .foregroundColor(Color.ButtonColor)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(8)
            }
            .padding(.bottom, 20)

            ForEach(candidates.indices, id: \.self) { index in
                VStack {
                    HStack {
                        TextField("Candidate \(index + 1)", text: Binding(
                            get: { self.candidates[index] },
                            set: { self.candidates[index] = $0 }
                        ))
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .onTapGesture {
                            self.selectedIndex = index
                            self.showUserList = true
                        }

                        if let image = selectedImages[index] {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .cornerRadius(8)
                        } else {
                            Button {
                                self.isShowingImagePicker = true
                                self.selectedIndex = index
                            } label: {
                                Image(systemName: "photo")
                            }
                            .sheet(isPresented: $isShowingImagePicker, onDismiss: loadImage) {
                                ImagePicker(selectedImage: self.$selectedImages[self.selectedIndex])
                            }
                        }

                        Button(action: {
                            self.deleteCandidate(at: index)
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                    if showUserList && selectedIndex == index {
                        List(viewModel.filteredUsers) { user in
                            Text(user.name ?? "Unknown")
                                .onTapGesture {
                                    self.candidates[selectedIndex] = user.username ?? "Unknown"
                                    self.showUserList = false
                                }
                        }
                        .frame(maxHeight: 200) // Limit the height of the list
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 5)
    }

    func loadImage() {
        guard let inputImage = selectedImage else { return }
        selectedImages[selectedIndex] = inputImage
    }

    func addMultipleCandidates() {
        let newCandidateNames = newCandidates.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        candidates.append(contentsOf: newCandidateNames)
        selectedImages.append(contentsOf: Array(repeating: nil, count: newCandidateNames.count))
        newCandidates = "" // Clear the input field
    }

    func deleteCandidate(at index: Int) {
        candidates.remove(at: index)
        selectedImages.remove(at: index)
    }
}

struct AddCandidateView_Previews: PreviewProvider {
    static var previews: some View {
        AddCandidateView(
            candidates: .constant(["Candidate 1", "Candidate 2"]),
            selectedImages: .constant([nil, nil])
        )
        .environmentObject(VotingEventViewModel())
    }
}
struct LabelText: View {
    var label: String

    var body: some View {
        Text(label)
            .font(.headline)
            .padding(.bottom, 5)
    }
}
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.selectedImage = uiImage
            }

            picker.dismiss(animated: true)
        }
    }
}
