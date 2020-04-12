import SwiftUI
import Promises



struct DisplayPlayerGroupRow : View {
    var group : PlayGroup
    var isSelected : Bool
    
    var body : some View {
        HStack{
            Text(group.groupName)
                 .textStyle(size: 16)
                .padding(.horizontal, 10)
                .frame(maxWidth:UIScreen.main.bounds.width / 3 , alignment: .leading)
            Text("\(group.players.count) 人")
                .textStyle(size: 12)
                .padding(.horizontal, 10)
            Text("\(group.startFan)番起糊 \(group.endFan)番止")
                .textStyle(size: 12)
            Spacer()
            if isSelected{
                Image(systemName: "checkmark")
                .padding(.horizontal, 10)
            }
        }
    }
}
