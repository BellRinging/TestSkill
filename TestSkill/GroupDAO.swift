//
//  GroupDAO.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 10/1/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import Foundation

public struct GroupDAO {
    public let id : String
    public let players : [String:String]
    public let rule : [Int:Int]
    public let groupName: String
}
