//
//  LocationViewModel.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 28/5/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//
import Foundation
import SwiftUI

class LocationViewModel : ObservableObject {
    
    @Published var locations : [String] = []
    @Binding var closeFlag : Bool
    @Binding var refLocation : String
    
    
    init(closeFlag : Binding<Bool>,location : Binding<String>){
        self._closeFlag = closeFlag
        self._refLocation = location
        self.loadLocation()
    }
    
    func loadLocation(){
        
    }
    
    func confirm(){
        self.closeFlag = false
    }
    
}
