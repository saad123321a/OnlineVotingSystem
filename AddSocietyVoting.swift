import SwiftUI

import AVKit

struct Panel {
    let id = UUID()
    var candidates: [Candidate] = [Candidate()]
    var agenda: String = "" // New property for agenda
}


struct Candidate: Identifiable {
    let id = UUID()
    var name: String = ""
    var image: UIImage? = nil
    var selectedImage: UIImage? = nil
}

struct AddSocietyVoting: View {
    @State private var selectedImage: UIImage? = nil
    @State private var isShowingImagePicker = false
    @State private var showSheet: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @State private var votingTitle = ""
    @State private var panels: [Panel] = [Panel()]
    @State private var selectedIndex = 0
    @State private var panelCount = 1 // Track panel count
    
    @State private var isShowingVideoPicker = false
    @State private var selectedVideoURL: URL?
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Text("BIIT Voting System")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 20)
                    
                    VStack {
                        LabelText(label: "Society Title")
                        TextField("Enter Society title", text: $votingTitle)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                    ScrollView {
                        VStack(alignment: .leading) {
                           
                            
                            
                            ForEach(Array(panels.enumerated()), id: \.offset) { index, panel in
                                PanelView(panel: $panels[index], selectedImage: $selectedImage, isShowingImagePicker: $isShowingImagePicker, selectedIndex: $selectedIndex, count: index + 1) { panel in
                                    self.deletePanel(panel: panel)
                                }
                            }

                            .padding()
                            .background(Color.white)
                            .cornerRadius(18)
                            .shadow(radius: 5)
                            
                            Button(action: {
                                self.addPanel()
                            }) {
                                VStack {
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        Image(systemName: "plus")
                                            .foregroundColor(.red)
                                        Text("Add Panel").foregroundColor(Color.ButtonColor)
                                        Spacer()
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    Spacer()
                                }
                            }
                            .padding(.top)
                        }
                        .cornerRadius(15)
                        .padding(.horizontal)
                        .navigationBarTitle("Society Voting", displayMode: .inline)
                    }
                    
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
                }
                .padding(.horizontal)
            }.background(Color.BackgroundColor)
            
        }
    }
    
    func addPanel() {
        panels.append(Panel())
        panelCount += 1 // Increment panel count
    }
    
    func deletePanel(panel: Panel) {
        if let index = panels.firstIndex(where: { $0.id == panel.id }) {
            panels.remove(at: index)
            panelCount -= 1 // Decrement panel count
        }
    }
}

struct PanelView: View {
    @Binding var panel: Panel
    @Binding var selectedImage: UIImage?
    @Binding var isShowingImagePicker: Bool
    @Binding var selectedIndex: Int
    
    @State private var isShowingVideoPicker = false
    @State private var selectedVideoURL: URL?
    var count: Int // Panel number
    var deletePanel: (Panel) -> Void // Delete panel function
  
    var body: some View {
        VStack {
            HStack {
                Text("Panel \(count)")
                    .font(.headline)
                Spacer()
                Button(action: {
                    deletePanel(panel)
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
            
            TextField("Agenda", text: $panel.agenda) // TextField for agenda
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
           
            ForEach(panel.candidates.indices, id: \.self) { candidateIndex in
                CandidateRow(candidate: $panel.candidates[candidateIndex],  isShowingImagePicker: $isShowingImagePicker, selectedIndex: $selectedIndex, panel: $panel)
            }
            Button(action: {
                self.addCandidate()
            }) {
                HStack {
                    Image(systemName: "plus")
                        .foregroundColor(Color.ButtonColor)
                    Text("Add Candidate")
                        .foregroundColor(Color.ButtonColor)
                }
            }
            VStack {
                       videoPlayer
                       addVideoButton
                   }
                   .padding()

        }
        
        
    }
    
    private var videoPlayer: some View {
           Group {
               if let videoURL = selectedVideoURL {
                   VideoPlayer(player: AVPlayer(url: videoURL))
                       .frame(height: 300)
               } else {
                   Image(systemName: "play.circle.fill")
                              
                              .foregroundColor(.blue)
               }
           }
       }
    
    private var addVideoButton: some View {
            Button(action: {
                self.isShowingVideoPicker = true
            }) {
                Text("Add Video")
            }
            .sheet(isPresented: $isShowingVideoPicker) {
                VideoPicker(videoURL: self.$selectedVideoURL)
            }
        }

    
    func addCandidate() {
        panel.candidates.append(Candidate())
    }
}



struct CandidateRow: View {
    @Binding var candidate: Candidate
    @Binding var isShowingImagePicker: Bool
    @Binding var selectedIndex: Int
    @Binding var panel: Panel
    @State private var designation: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    deleteCandidate(candidate: candidate)
                }) {
                    Image(systemName: "minus.circle")
                        .foregroundColor(.red)
                }
            }
            HStack {
                TextField("Candidate Name", text: $candidate.name)
                    .frame(width: 180)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                Spacer()
                if let image = candidate.image ?? candidate.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .cornerRadius(8)
                } else {
                    Button {
                        if let selectedIndex = panel.candidates.firstIndex(where: { $0.id == candidate.id }) {
                            self.isShowingImagePicker = true
                            self.selectedIndex = selectedIndex
                        }
                    } label: {
                        Image(systemName: "photo")
                    }

                    .sheet(isPresented: $isShowingImagePicker) {
                        MyImagePicker(selectedImage: $candidate.selectedImage)
                    }
                }
            }
            
            HStack {
                TextField("Designation", text: $designation)
                    .frame(width: 180)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                Spacer()
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
    
    func deleteCandidate(candidate: Candidate) {
            panel.candidates.removeAll { $0.id == candidate.id }
        }
}



struct MyImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    
    init(selectedImage: Binding<UIImage?>) {
        _selectedImage = selectedImage
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: MyImagePicker
        
        init(_ parent: MyImagePicker) {
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

struct VideoPicker1: UIViewControllerRepresentable {
    @Binding var videoURL: URL?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ["public.movie"]
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(videoURL: $videoURL)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var videoURL: URL?

        init(videoURL: Binding<URL?>) {
            _videoURL = videoURL
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let url = info[.mediaURL] as? URL {
                videoURL = url
            }
            picker.dismiss(animated: true, completion: nil)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    }
}

struct AddSocietyVoting_Previews: PreviewProvider {
    static var previews: some View {
        AddSocietyVoting()
    }
}
