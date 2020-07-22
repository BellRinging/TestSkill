
import SwiftUI

struct GameRecordDisplayViewRow: View {
    
    var winner : User
    var loser : User
    var win : Int
    var fan : Int
    var amt : Int
    var groupUser : [User]
    var currUser : User
    
    
    init(gameRecords:GameRecord,currUser: User ,groupUser :[User]){
        print(gameRecords)
        self.win = gameRecords.win
        if win == 1 {
            winner = currUser
            loser = groupUser.filter{$0.id == gameRecords.to}.first!
        }else{
            winner = groupUser.filter{$0.id == gameRecords.to}.first!
            loser = currUser
//            print(gameRecords)
        }
        self.fan = gameRecords.fan
        self.amt = gameRecords.value
//        self.ty = gameRecords.period
        self.currUser = currUser
        self.groupUser = groupUser
    }

    var body: some View {
        VStack{
            HStack{
                VStack{
                    ImageView(withURL: self.winner.imgUrl).standardImageStyle()
                    Text("\(self.winner.userName)").textStyle(size: 10).frame(width: 60)
                }
                Text("\(fan) Fan")
                VStack{
                    ImageView(withURL: self.loser.imgUrl).standardImageStyle()
                    Text("\(self.loser.userName)").textStyle(size: 10).frame(width: 60)
                }
                Spacer()
                Text("\(amt)")
                    .foregroundColor(win == 1 ? Color.greenColor:Color.redColor)
                    .textStyle(size: 24)
            }
        }
    }
}

