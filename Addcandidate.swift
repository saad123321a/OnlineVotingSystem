////
////  Addcandidate.swift
////  Final_Year_Project
////
////  Created by Macboook on 26/05/2024.
////
//
//import SwiftUI
//
//struct Addcandidate: View {
//    @StateObject private var viewModel = ElectionViewModel()
//    @StateObject private var viewModel1 = VotingEventViewModel()
//    @State private var selectedImage: UIImage?
//    @State private var isShowingImagePicker = false
//    @State private var currentCandidateIndex: Int?
//
//    var body: some View {
//        NavigationStack {
//            VStack {
//                TextField("Search Users", text: $viewModel.searchText)
//                    .onChange(of: viewModel.searchText) { newValue in
//                        viewModel.filteredUsers = viewModel.users.filter {
//                            $0.name?.contains(newValue) ?? false || $0.username?.contains(newValue) ?? false
//                        }
//                    }
//                    .padding()
//                    .background(Color.gray.opacity(0.2))
//                    .cornerRadius(8)
//
//                List {
//                    ForEach(viewModel.filteredUsers) { user in
//                        Text(user.username ?? "No username")
//                            .onTapGesture {
//                                currentCandidateIndex = viewModel.candidates.count
//                                viewModel.addCandidate(name: user.username ?? "Unnamed", image: nil)
//                                isShowingImagePicker = true
//                            }
//                    }
//                }
//
//                ForEach(viewModel.candidates.indices, id: \.self) { index in
//                    HStack {
//                        if let image = viewModel.candidates[index].image {
//                            Image(uiImage: image)
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 50, height: 50)
//                        } else {
//                            Button("Add Photo") {
//                                currentCandidateIndex = index
//                                isShowingImagePicker = true
//                            }
//                        }
//                        Text(viewModel.candidates[index].name)
//                        Spacer()
//                        Button(action: {
//                            viewModel.candidates.remove(at: index)
//                        }) {
//                            Image(systemName: "minus.circle.fill")
//                                .foregroundColor(.red)
//                        }
//                    }
//                    .padding()
//                }
//
//                Button("Submit Candidates") {
//                    viewModel.submitCandidates(eventID: viewModel1.selectedEventID ?? 0
//                                               
//                    )
//                }
//                .padding()
//                .background(Color.blue)
//                .foregroundColor(.white)
//                .cornerRadius(8)
//            }
//            .sheet(isPresented: $isShowingImagePicker, onDismiss: loadImage) {
//                ImagePicker(selectedImage: $selectedImage)
//            }
//        }
//    }
//
//    func loadImage() {
//        guard let selectedImage = selectedImage, let index = currentCandidateIndex else { return }
//        viewModel.candidates[index].image = selectedImage
//    }
//}
//
//struct ImagePicker1: UIViewControllerRepresentable {
//    @Binding var selectedImage: UIImage?
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    func makeUIViewController(context: Context) -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.delegate = context.coordinator
//        picker.sourceType = .photoLibrary
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
//
//    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//        var parent: ImagePicker1
//
//        init(_ parent: ImagePicker1) {
//            self.parent = parent
//        }
//
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            if let uiImage = info[.originalImage] as? UIImage {
//                parent.selectedImage = uiImage
//            }
//            picker.dismiss(animated: true)
//        }
//    }
//}
//
//
//struct Addcandidate_Previews: PreviewProvider {
//    static var previews: some View {
//        Addcandidate()
//    }
//}
