import SwiftUI
import SwiftUICharts // Import SwiftUICharts library

struct UserSurvey: View {
    let question: String
    let options: [String]
    @State private var selectedOptionIndex: Int?
    @State private var selectedOptionPercentage: Double = 0.0 // Track the percentage of the selected option
    
    init(question: String, options: [String]) {
        self.question = question
        self.options = options
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(question)
                .font(.title)
                .padding(.bottom, 20)
            
            ForEach(options.indices, id: \.self) { index in
                OptionView(option: options[index],
                           isSelected: selectedOptionIndex == index,
                           percentage: selectedOptionIndex == index ? selectedOptionPercentage : 0.0,
                           onTap: { self.selectOption(at: index) })
            }
            
            Spacer()
        }
        .padding()
    }
    
    private func selectOption(at index: Int) {
        selectedOptionIndex = index
        calculatePercentages()
    }
    
    private func calculatePercentages() {
        guard let selectedOptionIndex = selectedOptionIndex else { return }
        let totalResponses = Double(options.count) // Assuming each user can select only one option
        let randomPercentages = Array(repeating: 0.0, count: options.count).map { _ in Double.random(in: 0...100) }
        let totalSum = randomPercentages.reduce(0, +)
        selectedOptionPercentage = randomPercentages[selectedOptionIndex] // Update selected option's percentage
    }
}

struct OptionView: View {
    let option: String
    let isSelected: Bool
    let percentage: Double
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button(action: onTap) {
                HStack {
                    Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .foregroundColor(isSelected ? .blue : .gray)
                    Text(option)
                        .font(.headline)
                        .foregroundColor(.black)
                }
                .padding()
            }
            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: isSelected ? 2 : 1))
            
            if isSelected {
                BarChartView(data: ChartData(values: [(label: option, value: percentage)]),
                             title: "\(Int(percentage))%",
                             legend: option,
                             style: ChartStyle(backgroundColor: .clear,
                                               accentColor: .blue,
                                               gradientColor: GradientColor(start: Color.blue, end: Color.blue),
                                               textColor: .black,
                                               legendTextColor: .gray,
                                               dropShadowColor: .gray),
                             form: ChartForm.medium)
                .frame(height: 200, alignment: .leading) // Adjust the height of the chart
                     // Expand the width of the chart to fill the available space
                    .rotationEffect(Angle(degrees: 0)) // Rotate the chart 90 degrees counterclockwise
            }
        }
    }
}

struct Result: View {
    
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            UserSurvey(
                question: "What is your favorite color?",
                       options: ["Red", "Blue", "Green", "Yellow"])
                .navigationBarTitle("Survey", displayMode: .inline)
//                .navigationBarItems(leading: Button("Back") {
//                    // Handle close action
//                },trailing: Button("Next") {
//                    // Handle close action
//                    
//                    presentationMode.wrappedValue.dismiss()
//                })
        }
    }
}

struct Result_Previews: PreviewProvider {
    static var previews: some View {
        Result()
    }
}
