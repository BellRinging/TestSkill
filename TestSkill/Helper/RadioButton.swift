
import SwiftUI

struct RadioButton: View {
    let text: String
    @Binding var radioSelection: String
    var body: some View {
        Button(action: {
            self.radioSelection = self.text
        }) {
            HStack {
                Circle()
                    .fill( $radioSelection.wrappedValue == text ? Color.primary : Color.clear)
                    .overlay(Circle().stroke(Color.primary))
                    .frame(width: 18, height: 18)
                Text(text)
                    .foregroundColor(Color.textColor)
            }
        }
        .buttonStyle(RadioButtonStyle())
    }
}
struct RadioButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
//            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(Color.clear)
    }
}

