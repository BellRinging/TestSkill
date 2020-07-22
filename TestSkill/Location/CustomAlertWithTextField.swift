import SwiftUI
import SwiftEntryKit

struct CustomAlertWithTextField: View{
    var title : String
    @Binding var returnText: String
    @Binding var closeFlag: Bool
    typealias PostAction = (() -> Void)
    var action: PostAction?
    
    init(title:String , returnText : Binding<String>, closeFlag : Binding<Bool>,action: PostAction? = nil){
        self.title = title
        self._returnText = returnText
        self._closeFlag = closeFlag
        self.action = action
        
    }
    
    
    @State var text : String = ""
    var body: some View{
        ZStack{
            VStack{
                Text(title).font(.headline).padding()
                TextField("Type text here", text: self.$text).textFieldStyle(RoundedBorderTextFieldStyle()).padding()
                Divider()
                HStack{
                    Spacer()
                    Button(action: {
                        self.returnText = self.text
//                        if let action = self.action {
                        self.action?()
//                        }
                        self.closeFlag.toggle()
                        SwiftEntryKit.dismiss()
                    }) {

                        Text("Done")
                    }
                    Spacer()

                    Divider()

                    Spacer()
                    Button(action: {
                        self.closeFlag.toggle()
                    }) {
                        Text("Cancel")
                    }
                    Spacer()
                }
            }.onAppear(){
                self.text = self.returnText 
            }
        }
        .background(Color(white: 0.9))
        .frame(width: 300, height: 200)
        .cornerRadius(20)
    }
    
    func dummyFunction() {
        
    }
}
