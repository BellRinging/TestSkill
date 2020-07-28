import SwiftUI
import FirebaseAuth
import  SwiftEntryKit

class PeriodSelectionViewModel: ObservableObject {

    @Published var items : [String] = []
    @Binding var returnItem : String
    @Binding var closeFlag : Bool
    
    init(returnItem:Binding<String>,closeFlag:Binding<Bool>){
        self._returnItem = returnItem
        self._closeFlag = closeFlag
        let cm = Utility.getCM()
        let cy = Utility.getCurrentYear()
        let ly = Utility.getPerviousYear()
        var periods : [String] = []
        for i in 1...12{
            let abc = "0\(i)".suffix(2)
            periods.append("\(ly)\(abc)")
        }
        for i in 1...12{
            let abc = "0\(i)".suffix(2)
            let period = "\(cy)\(abc)"
            if cm != period {
                periods.append(period)
            }else{
                periods.append(period)
                break
            }
        }
        self.items = periods.sorted{$0>$1}
    }
    
    func confirm(index:Int){
        returnItem = self.items[index]
        closeFlag.toggle()
    }
    
   
}
