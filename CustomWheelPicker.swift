import SwiftUI
struct CustomWheelPicker: View {
    @Binding var selection: Int
    let range: [Int]
    let label: String

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    ForEach(range, id: \.self) { value in
                        Text("\(value) \(label)")
                            .font(.title3)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(selection == value ? Color.blue.opacity(0.2) : Color.clear)
                            .cornerRadius(8)
                            .onTapGesture {
                                withAnimation {
                                    selection = value
                                }
                            }
                            .id(value) // Assign an ID to each item for ScrollViewReader
                    }
                }
            }
            .onAppear {
                // Scroll to the selected value when the picker appears
                proxy.scrollTo(selection, anchor: .center)
            }
            .onChange(of: selection) { newValue in
                // Scroll to the new selected value
                withAnimation {
                    proxy.scrollTo(newValue, anchor: .center)
                }
            }
        }
        .frame(width: 120, height: 250) // Increased height for vertical extension
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}
