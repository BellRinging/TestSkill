import SwiftUI

struct LocationRow: View {
    var text : String
    var isSelected : Bool
    
    var body: some View {
        HStack{
            Text(text)
            Spacer()
            if self.isSelected {
                Image(systemName: "checkmark")
            }
        }.padding()
    }
}

