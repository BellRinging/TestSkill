//
//  DsiplayViewFriendViewOption.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 31/10/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import Foundation
import SwiftUI


struct DisplayFriendViewOption{
    var closeFlag : Binding<Bool>
    var users : Binding<[User]>
    var maxSelection : Int = 999
    var includeSelfInReturn : Bool = true
    var onlyInUserGroup : Bool = false
    var hasDetail : Bool = false
    var acceptNoReturn : Bool = false
    var showSelectAll : Bool = true
    var showAddButton:Bool = false
    var includeSelfInSeletion:Bool = false
    
    init(closeFlag : Binding<Bool> , users : Binding<[User]> ,maxSelection : Int = 999 ,includeSelfInReturn : Bool = true , onlyInUserGroup : Bool = false,hasDetail : Bool = false,acceptNoReturn : Bool = false , showSelectAll : Bool = true,showAddButton:Bool = false,includeSelfInSeletion:Bool = false){
    
    self.closeFlag = closeFlag
    self.users = users
    self.maxSelection = maxSelection
    self.includeSelfInReturn = includeSelfInReturn
    self.onlyInUserGroup = onlyInUserGroup
    self.hasDetail = hasDetail
    self.acceptNoReturn = acceptNoReturn
    self.showSelectAll  = showSelectAll
    self.showAddButton = showAddButton
    self.includeSelfInSeletion = includeSelfInSeletion
    
    }
}
