import SwiftUI

struct GameView: View {
        
    @ObservedObject var viewModel: GameViewModel
    @State var isShowing : Bool = false
    
    init(){
        print("GameView init")
        viewModel = GameViewModel.shared
        viewModel.status = .loading
        viewModel.onInitialCheck()
        
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
                        GameViewUpperArea(user: self.$viewModel.currentUser, credit: self.viewModel.mthCredit,debit: self.viewModel.mthDebit)
                        GameViewListHistoryArea(groupUsers: self.viewModel.groupUsers, sectionHeader: self.viewModel.sectionHeader, sectionHeaderAmt: self.viewModel.sectionHeaderAmt,games: self.viewModel.games, status: self.viewModel.status,lastGameDetail: self.viewModel.lastGameDetail,lastBig2GameDetail: self.viewModel.lastBig2GameDetail, callback: self.viewModel.deleteGame)
                            .pullToRefresh(isShowing: self.$isShowing) {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.viewModel.loadMoreGame()
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
                FlownGameView(closeFlag: self.$viewModel.showingFlownView, game: self.viewModel.gameForFlown!)
            }
      
        }.onAppear(){
            self.self.viewModel.loadGameBalance()
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
