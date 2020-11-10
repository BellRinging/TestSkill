
import Foundation
import SwiftUI
import Combine


class GameUpperViewModel: ObservableObject {
    
    var showPercent : Bool = true
    var balance: Int
    var currentMth: Int
    var lastMth: Int
    var lastYTM: Int
    var mtlm : String = "N/A"
    var mtly : String = "N/A"
    
    init(balanceObj: UpperResultObject){
        self.balance = balanceObj.balance
        self.currentMth = balanceObj.currentMth
        self.lastMth = balanceObj.lastMth
        self.lastYTM = balanceObj.lastYTM
        self.showPercent = balanceObj.showPercent
        
        if showPercent {
            var diff = currentMth - lastMth
            if lastMth != 0 {
                var percent = Int(Float(diff) / abs(Float(lastMth))  * 100)
                self.mtlm = diff > 0 ? "+\(percent)%" : "\(percent)%"
            }
            diff = balance - lastYTM
            if lastYTM != 0 {
                var percent = Int(Float(balance) / abs(Float(lastYTM))  * 100)
                self.mtly = diff > 0 ? "+\(percent)%" : "\(percent)%"
            }
        }else{
            var diff = currentMth - lastMth
            self.mtlm = diff > 0 ? "+\(diff)" : "\(diff)"
            diff = balance - lastYTM
            self.mtly = diff > 0 ? "+\(diff)" : "\(diff)"
        }
    
    }

}
