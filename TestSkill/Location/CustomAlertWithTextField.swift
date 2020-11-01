import SwiftUI
import SwiftEntryKit

struct CustomAlertWithTextField: View{
    var title : String
    @Binding var returnText: String
    typealias PostAction = (() -> Void)
    var action: PostAction?
    
    init(title:String , returnText : Binding<String>,action: PostAction? = nil){
        self.title = title
        self._returnText = returnText
        self.action = action
    }
    
    
    @State var text : String = ""
    var body: some View{
        ZStack{
            VStack{
                Text(title).font(.headline).padding([.horizontal,.top])
                TextField("Type text here", text: self.$text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
//                    .frame(height: 50)
                Divider()
                HStack(alignment: .center){
                    Spacer()
                    Button(action: {
                        self.returnText = self.text
                        self.action?()
                        SwiftEntryKit.dismiss()
                    }) {

                        Text("Confirm").textStyle(size: 16,color: Color.primary)
                    }
                    Spacer()

                    Divider()
                    Spacer()
                    Button(action: {
                        SwiftEntryKit.dismiss()
                    }) {
                        Text("Cancel").textStyle(size: 16, color: Color.red)
                    }
                    Spacer()
                }.frame(height: 40)
            }.onAppear(){
                self.text = self.returnText 
            }
        }
        .background(Color(white: 1))
        .frame(width: 300)
        .cornerRadius(20)
    }
    
    func dummyFunction() {
        
    }
}
