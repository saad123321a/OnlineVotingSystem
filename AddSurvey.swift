import SwiftUI

struct Question {
    var text: String
    var options: [String]
}

struct SurveyCreationView: View {
    @State private var questions: [Question] = [Question(text: "", options: [""])]
    @State private var showSheet: Bool = false
    @State private var surveyTitle = ""

    var body: some View {
        NavigationView {
            VStack {
                Text("BIIT Voting System")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                surveyInformationSection
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {


                        ForEach(questions.indices, id: \.self) { index in
                            QuestionView(question: $questions[index]) {
                                removeQuestion(at: index)
                            }
                        }

                        addQuestionButton
                    }
                    .padding()
                    .background(Color.white.cornerRadius(20))
                    //.padding(.horizontal)
                }

                Spacer()

                navigationButtons
            }.padding(.horizontal)
            .background(Color.BackgroundColor.ignoresSafeArea())
            .navigationBarTitle("Add Survey", displayMode: .inline)
        }
    }

    private var surveyInformationSection: some View {
        VStack {
            LabelText(label: "Survey Title")
            TextField("Enter Survey title", text: $surveyTitle)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
        }
    }

    private var addQuestionButton: some View {
        Button(action: addQuestion) {
            HStack {
                Image(systemName: "plus")
                Text("Add Question")
            }
            .foregroundColor(Color.ButtonColor)
        }
    }

    private var navigationButtons: some View {
        HStack {
            Spacer()

            Button(action: {
                showSheet.toggle()
            }) {
                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(Color.ButtonColor)
                    .font(.title)
                    .padding(20)
                    .background(Color.white.cornerRadius(10))
            }
            .sheet(isPresented: $showSheet) {
                PopulationSelectionView()
            }

            Button(action: {}) {
                Text("Submit")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.ButtonColor)
                    .cornerRadius(8)
            }
        }
        .padding()
    }

    private func addQuestion() {
        questions.append(Question(text: "", options: [""]))
    }

    private func removeQuestion(at index: Int) {
        questions.remove(at: index)
    }
}

struct QuestionView: View {
    @Binding var question: Question
    var onDelete: () -> Void

    var body: some View {
        VStack(spacing: 10) {
            TextField("Enter Question", text: $question.text)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            ForEach(question.options.indices, id: \.self) { index in
                HStack {
                    TextField("Option \(index + 1)", text: $question.options[index])
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: {
                        removeOption(at: index)
                    }) {
                        Image(systemName: "minus.circle")
                            .foregroundColor(.red)
                    }
                }
            }

            Button(action: {
                addOption()
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Option")
                }
                .foregroundColor(Color.ButtonColor)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .overlay(
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .padding()
                    .foregroundColor(.red)
            }
            .padding(.all, 8)
            .offset(x: -10, y: -10)
            , alignment: .topTrailing
        )
    }

    private func addOption() {
        question.options.append("")
    }

    private func removeOption(at index: Int) {
        question.options.remove(at: index)
    }
}

struct SurveyCreationView_Previews: PreviewProvider {
    static var previews: some View {
        SurveyCreationView()
    }
}



//struct LabelText: View {
//    var label: String
//
//    var body: some View {
//        Text(label)
//            .font(.headline)
//    }
//}
