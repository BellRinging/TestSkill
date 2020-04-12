import SwiftUI
//import SwiftEntryKit

struct CancelButton : View {
    @Binding var closeFlag : Bool
    
    init(_ closeFlag : Binding<Bool>){
        self._closeFlag = closeFlag
    }
    
    var body: some View {
        Button(action: {
            withAnimation {
                self.closeFlag.toggle()
            }
        }) {
            HStack{
//            Image(systemName: "xmark")
//                .contentShape(Rectangle())
                Text("Close")
            }
        }
    }
}

