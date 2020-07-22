import SwiftUI
import Combine


struct DisplayPlayerGroupView: View {
    
    @ObservedObject var viewModel: DisplayPlayGroupViewModel
    

    var groupUsers : [User] = []
    
    init(closeFlag : Binding<Bool> ,returnGroup : Binding<PlayGroup?> = Binding.constant(nil) ,  needReturn: Bool = false ){
        viewModel = DisplayPlayGroupViewModel(closeFlag: closeFlag,returnGroup:returnGroup, needReturn: needReturn)
    }
    
    func displayRow(group : PlayGroup) -> some View{
        DisplayPlayerGroupRow(group: group, isSelected: self.viewModel.selectedGroup == group)
            .contentShape(Rectangle())
            .onTapGesture {
                print("needReturn :\(self.viewModel.needReturn )")
                if self.viewModel.needReturn {
                    UserDefaults.standard.removeObject(forKey: UserDefaultsKey.CurrentGroupUser)
                    UserDefaults.standard.save(customObject: group, inKey: UserDefaultsKey.CurrentGroup)
                    self.viewModel.returnGroup = group
                    print("Remove group user from UserObject")
                    self.viewModel.closeFlag.toggle()
                }else{
                    self.viewModel.selectedGroup = group
                }
        }
    }
    
    var body : some View {
         NavigationView {
            List{
                ForEach(0..<viewModel.groups.count , id:\.self) { row in
                    self.displayRow(group:self.viewModel.groups[row])
                    }
                .onDelete { (index) in
                    self.viewModel.selectedIndex = index.first!
                    self.viewModel.showingDeleteAlert = true
                }
                }

            .navigationBarTitle("Game Group", displayMode: .inline)
            .navigationBarItems(leading: CancelButton(self.$viewModel.closeFlag), trailing: RightButton())
            }
         .modal(isShowing: self.$viewModel.showAddingGroup) {
            if self.viewModel.isAdd {
                AddPlayGroupView(closeFlag: self.$viewModel.showAddingGroup)
            }else{
                AddPlayGroupView(closeFlag: self.$viewModel.showAddingGroup, editGroup: self.$viewModel.selectedGroup)
            }
        }
         .modal(isShowing: self.$viewModel.showStatistic) {
            ResultView(closeFlag: self.$viewModel.showStatistic)
         }
        .alert(isPresented: self.$viewModel.showingDeleteAlert) {
            Alert(title: Text("Confirm delete"), message: Text("Are you sure?"), primaryButton: .destructive(Text("Delete")) {
                self.viewModel.deleteGroup(index:self.viewModel.selectedIndex)
                }, secondaryButton: .cancel()
            )
        }
    }
    
    func delete(at offsets: IndexSet) {
         viewModel.groups.remove(atOffsets: offsets)
     }
    
    
    func RightButton() -> some View{
        HStack{
            if self.viewModel.groups.count > 0 && self.viewModel.selectedGroup != nil{
                Button(action: {
                    self.viewModel.showAddingGroup = true
                    self.viewModel.isAdd = false
                }) {
                    Image(systemName: "square.and.pencil")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20,height: 20)
                }.padding(.trailing,5)
                Button(action: {
                    self.viewModel.showStatistic = true
                }) {
                    Image(systemName: "s.square")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20,height: 20)
                }
            }
          
            Button(action: {
                self.viewModel.showAddingGroup = true
                self.viewModel.isAdd = true
            }) {
                 Image(systemName: "plus")
                       .resizable()
                       .scaledToFit()
                       .frame(width: 20,height: 20)
            }.padding(.leading,5)
        }
        
    }
}





