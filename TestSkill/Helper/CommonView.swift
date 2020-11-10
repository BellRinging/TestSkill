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
                Text("Close")
            }
        }
    }
}

struct ConfirmButton : View {
    
    var action : ()->()
    
    var body: some View {
        Button(action: {
            self.action()
        }, label:{
            Text("確認")
                .foregroundColor(Color.white)
        }).padding()
            .shadow(radius: 5)
    }
}


struct UserDisplay: View {
    
    var size : Int
    var url : String
    var name : String
    
    init( url : String , name : String,size:Int = 40){
        self.size = size
        self.url = url
        self.name = name
    }
    init( user : User,size:Int = 40){
        self.size = size
        self.url = user.imgUrl
        self.name = user.userName
    }
    
    var body: some View {
        VStack{
            ImageView(withURL: url).ImageStyle(size: CGFloat(size))
            Text(name)
                .textStyle(size: 10)
                .frame(width: 60)
        }
        
    }
}

