import SwiftUI

struct GameView: View {
        
    @ObservedObject var viewModel: GameViewModel
    @State var isShowing : Bool = false
    
    init(){
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
                        GameViewUpperArea(balanceObj: self.viewModel.balanceObject)
                            .onTapGesture {
                                self.viewModel.balanceObject.showPercent.toggle()
                            }
                            .overlay(self.actAsUser)
                        if (self.viewModel.games.list.count > 0) {
                            GameViewListArea(games: self.$viewModel.games)
                                .pullToRefresh(isShowing: self.$isShowing) {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        self.viewModel.loadGame()
                                        self.isShowing = false
                                    }
                                }
                        }
                        Spacer()
                    }
                    navigationArea
                }
                .navigationBarItems(leading: self.dropDown.padding(.leading , (geometry.size.width-200-20) / 2.0), trailing: self.rightImg)
                .navigationBarTitle("", displayMode: .inline)
            }
        }
    }
    
    var navigationArea : some View {
        VStack{
            EmptyView()
                .fullScreenCover(isPresented: self.$viewModel.showGroupDisplay){
                    DisplayPlayerGroupView(closeFlag: self.$viewModel.showGroupDisplay,returnGroup : self.$viewModel.group ,needReturn: true)
                }
            EmptyView()
                .fullScreenCover(isPresented: self.$viewModel.showAddGameDisplay){
                    AddGameView(closeFlag: self.$viewModel.showAddGameDisplay ).equatable()
                }
            
            EmptyView()
                .fullScreenCover(isPresented: self.$viewModel.showingFlownView) {
                    MarkFlownView(closeFlag: self.$viewModel.showingFlownView, game: self.viewModel.gameForFlown!).equatable()
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
    
    var actAsUser : some View {
        HStack{
            if self.viewModel.actAsUser != nil {
                UserDisplay(url: self.viewModel.actAsUser!.imgUrl, name: self.viewModel.actAsUser!.userName)
            }
            Spacer()
        }
    }

}





