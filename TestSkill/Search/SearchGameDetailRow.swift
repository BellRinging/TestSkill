import SwiftUI

struct SearchGameDetailRow: View {
    
    @ObservedObject var viewModel: SearchGameDetailRowViewModel
    
    init(gameDetail:GameDetail,refUser: User?){
        viewModel = SearchGameDetailRowViewModel(gameDetail:gameDetail ,refUser : refUser)
    }
    
    var body: some View {
        VStack{
            if self.viewModel.winType == "draw"{
                drawView()
            }else if self.viewModel.winType == "Self" || self.viewModel.winType == "Other" {
                normalView()
            }else{
                specialView()
            }
        }
    }
    
    func specialView() -> some View{
        HStack{
            Circle()
                          .fill(Color.greenColor)
                       .frame(width: 20 ,height: 20)
//                          .padding([.leading,.trailing] , 10)
                          .overlay(
                            Text("\(self.viewModel.detailNo)").textStyle(size: 10,color:Color.white)
                      )
            ForEach(self.viewModel.whoLose ) { (lose) in
                VStack{
                    ImageView(withURL: lose.imgUrl).standardImageStyle()
                    Text(lose.userName).textStyle(size: 10).frame(width: 45)
                    if self.viewModel.refUser == nil {
                        Text("\(self.viewModel.userAmount[lose.id]!)").textStyle(size: 10, color: self.viewModel.userAmount[lose.id]! >= 0 ? Color.greenColor:Color.redColor)
                    }
                }.frame(width: 45)
            }
            
            Text("Special").textStyle(size: 10)
               .frame(width: 30)
            
            ForEach(self.viewModel.whoWin) { (win) in
                VStack{
                    ImageView(withURL: win.imgUrl).standardImageStyle()
                    Text(win.userName).textStyle(size: 10).frame(width: 45)
                    if self.viewModel.refUser == nil {
                        Text("\(self.viewModel.userAmount[win.id]!)").textStyle(size: 10, color: self.viewModel.userAmount[win.id]! >= 0 ? Color.greenColor:Color.redColor)
                    }
                }.frame(width: 45)
            }
            
            Spacer()
            if self.viewModel.refUser != nil {
                Text("\(self.viewModel.refAmount)").textStyle(size: 20,color: self.viewModel.refAmount >= 0 ? Color.greenColor:Color.redColor)
            }
        }
    }
    
    func normalView() -> some View{
        HStack{
            Circle()
                .fill(Color.greenColor)
                .frame(width: 20 ,height: 20)
//                .padding([.leading,.trailing] , 10)
                .overlay(
                  Text("\(self.viewModel.detailNo)").textStyle(size: 10,color:Color.white)
            )
            
            ForEach(self.viewModel.whoWin) { (win) in
                VStack{
                    ImageView(withURL: win.imgUrl).standardImageStyle()
                    Text(win.userName).textStyle(size: 10).frame(width: 45)
                    if self.viewModel.refUser == nil {
                        Text("\(self.viewModel.userAmount[win.id]!)").textStyle(size: 10, color: self.viewModel.userAmount[win.id]! >= 0 ? Color.greenColor:Color.redColor)
                    }
                }.frame(width: 45)
            }
            VStack{
                VStack{
                    Text(self.viewModel.winType == "Self" ? "自摸":"打出").textStyle(size: 10).padding(.trailing,2)
                    Text("\(self.viewModel.fan) 番").textStyle(size: 10)
                }.frame(width: 30)
            }
            ForEach(self.viewModel.whoLose ) { (lose) in
                VStack{
                    ImageView(withURL: lose.imgUrl).standardImageStyle()
                    Text(lose.userName).textStyle(size: 10).frame(width: 45)
                    if self.viewModel.refUser == nil {
                        Text("\(self.viewModel.userAmount[lose.id]!)").textStyle(size: 10, color: self.viewModel.userAmount[lose.id]! >= 0 ? Color.greenColor:Color.redColor)
                    }
                }.frame(width: 45)
            }
            Spacer()
            if self.viewModel.refUser != nil {
                Text("\(self.viewModel.refAmount)").textStyle(size: 20,color: self.viewModel.refAmount >= 0 ? Color.greenColor:Color.redColor)
            }
        }
        
    }
    
    func drawView() -> some View{
        
        HStack{
            Circle()
                          .fill(Color.greenColor)
                          .frame(width: 20 ,height: 20)
//                          .padding([.leading,.trailing] , 10)
                          .overlay(
                            Text("\(self.viewModel.detailNo)").textStyle(size: 10,color:Color.white)
                      )
            ForEach(self.viewModel.whoLose) { (lose) in
                VStack{
                    ImageView(withURL: lose.imgUrl).standardImageStyle()
                    Text(lose.userName).textStyle(size: 10).frame(width: 45)
                    if self.viewModel.refUser == nil {
                        Text("\(self.viewModel.userAmount[lose.id]!)").textStyle(size: 10, color: self.viewModel.userAmount[lose.id]! >= 0 ? Color.greenColor:Color.redColor)
                    }
                }.frame(width: 45)
            }
            Spacer()
            if self.viewModel.refUser != nil {
                Text("\(self.viewModel.refAmount)").textStyle(size: 20,color: self.viewModel.refAmount >= 0 ? Color.greenColor:Color.redColor)
            }
        }
    }
    

}
