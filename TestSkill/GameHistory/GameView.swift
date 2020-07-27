import SwiftUI

struct GameView: View {
        
    @ObservedObject var viewModel: GameViewModel
    @State var isShowing : Bool = false
    
    init(){
        viewModel = GameViewModel.shared
        print("init Game")
        viewModel.status = .loading
        viewModel.onInitialCheck()
        
    }
    
    var actAsUser : some View {
        HStack{
            if self.viewModel.actAsUser != nil {
                UserDisplay(url: self.viewModel.actAsUser!.imgUrl, name: self.viewModel.actAsUser!.userName)
            }
            Spacer()
        }
        
    }

    var body: some View {
        GeometryReader { geometry in
            NavigationView{
                VStack{
                    if (self.viewModel.status == .loading || self.viewModel.group == nil) {
                        if  self.viewModel.group == nil{
                                Text("No game group was setup , please Setup the game group first")
                            .lineLimit(nil).fixedSize(horizontal: false, vertical: true)
                        }else{
                                Text("loading...")
                        }
                    }else{
                        GameViewUpperArea(balanceObj: self.viewModel.balanceObject,showPercent:self.viewModel.showPercent).onTapGesture {
                            self.viewModel.showPercent.toggle()
                        }
                        .overlay(self.actAsUser)
                        GameViewListHistoryArea(games: self.viewModel.games, status: self.viewModel.status,lastGameDetail: self.viewModel.lastGameDetail,lastBig2GameDetail: self.viewModel.lastBig2GameDetail, noMoreGame: self.viewModel.noMoreUpdate)
                            .pullToRefresh(isShowing: self.$isShowing) {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.viewModel.loadGame()
                                self.isShowing = false
                            }
                        }
                        Spacer()
                    }
                }
                .navigationBarItems(leading: self.dropDown.padding(.leading , (geometry.size.width-200-20) / 2.0), trailing: self.rightImg)
                .navigationBarTitle("", displayMode: .inline)
            }
            .modal(isShowing: self.$viewModel.showGroupDisplay, content: {
                DisplayPlayerGroupView(closeFlag: self.$viewModel.showGroupDisplay,returnGroup : self.$viewModel.group ,needReturn: true)
            })
            .modal(isShowing: self.$viewModel.showAddGameDisplay, content: {
                AddGameView(closeFlag: self.$viewModel.showAddGameDisplay )
            })
            .modal(isShowing: self.$viewModel.showingFlownView) {
                MarkFlownView(closeFlag: self.$viewModel.showingFlownView, game: self.viewModel.gameForFlown!)
            }
      
        }

    }

    var dropDown : some View {
        VStack {
            Text(self.viewModel.group?.groupName ?? "")
                .foregroundColor(Color.white)
                .titleStyle()
        }
        .frame(width: 200)
        .background(Color.clear)
        .onTapGesture {
            withAnimation {
                self.viewModel.showGroupDisplay = true
            }
        }
    }
    
    var rightImg : some View {
        
        Button(action: {
            withAnimation {
                self.viewModel.showAddGameDisplay = true
            }
        }) {
            Image(systemName: "plus")
                .resizable()
                .scaledToFit()
                .frame(width: 20,height: 20)
        }
    }
}

struct UpperResultObject {
    var balance: Int = 0
    var currentMth: Int = 0
    var lastMth: Int = 0
    var lastYTM: Int = 0
    var mtlm : String = "N/A"
    var mtly : String = "N/A"
}





