import SwiftUI
import Promises



struct AddGameViewRow : View {
    var players : [User]
    
    var body : some View {
        VStack{
            if players.count == 0 {
                Text("Tap to add player")
            }else{             
                HStack{
                    Spacer()
                    ForEach(players ,id: \.id) { (player) in
                        UserDisplay(user: player)
                    }
                    Spacer()
                }.padding()
             
            }
        }
    }
}
