//
//  TestMain.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 4/1/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI
import Combine

struct GameHistoryView: View {
        
    @ObservedObject var viewModel: GameHistoryViewModel
    @State var isPresent = false
    
    private var tickets: [AnyCancellable] = []

    
    init(){
        viewModel = GameHistoryViewModel()
    }
    
    var detail : some View {
        
        ScrollView{
            Section(header: self.sectionArea(amt: 1000, month: "6月")) {
                TestGameRow()
                TestGameRow()
                TestGameRow()
                TestGameRow()
            }
            Section(header: self.sectionArea(amt: 2000, month: "7月")) {
                TestGameRow()
                TestGameRow()
                TestGameRow()
                TestGameRow()
            }
        }
            
    }
    
    var body: some View {
        ZStack{
            originalBody
            ZStack{
                DisplayPlayerGroupView(parent: viewModel)
            }.background(Color.red)
                .offset(x:0,y: self.viewModel.showGroupDisplay ? 0 : UIScreen.main.bounds.height * -1)
        }
    }
    
    
    var originalBody : some View {

        NavigationView{
            VStack{
                VStack{
                    self.amountArea(amt: "1003", text: "6月結餘")
                    HStack{
                        Spacer()
                        self.amountArea(amt: "1003", text: "6月收入")
                        Spacer()
                        self.amountArea(amt: "1003", text: "6月支出")
                        Spacer()
                    }.padding()

                }.background(Color.red)
                /*
                 ScrollView{
                 Section(header: self.sectionArea(amt: 1000, month: "6月")) {
                 TestGameRow()
                 TestGameRow()
                 TestGameRow()
                 TestGameRow()
                 }
                 Section(header: self.sectionArea(amt: 2000, month: "7月")) {
                 TestGameRow()
                 TestGameRow()
                 TestGameRow()
                 TestGameRow()
                 }
                 }
                 */
                Spacer()
            }
            .navigationBarItems(leading: self.dropDown.padding(.leading ,80), trailing: self.rightImg)
            .navigationBarTitle("", displayMode: .inline)
            .background(NavigationConfigurator { nc in
                nc.navigationBar.barTintColor = UIColor.red
                nc.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
            })
        }
//        .sheet(isPresented: $viewModel.showGroupDisplay){
//        }
        .onAppear {
        }
    }
    
    

    var dropDown : some View {
        VStack {
            Text(self.viewModel.groupName)
                .foregroundColor(Color.white)
                .titleStyle()
        }
//        .frame(width: 200)
        .background(Color.clear)
        .onTapGesture {
            withAnimation {
                self.viewModel.showGroupDisplay = true
            }
        }
    }
    
    func sectionArea(amt:Int,month:String) ->some View{
        HStack{
            Text(month)
                .font(.footnote)
                .foregroundColor(Color.textColor)
            Spacer()
            Text("111")
                .font(.footnote)
                .foregroundColor(Color.textColor)
        }
    }
    
    func amountArea(amt: String , text : String) -> some View{
        VStack{
            Text(amt)
                .font(.title)
                .foregroundColor(SwiftUI.Color.white)
            Text(text)
                .font(.footnote)
                .foregroundColor(SwiftUI.Color.white)
        }
    }
    
    
    var rightImg : some View {
        Image(systemName: "ellipsis")
        .resizable()
        .scaledToFit()
        .accentColor(SwiftUI.Color.white)
    }
}

//struct TestMain_Previews: PreviewProvider {
//    static var previews: some View {
//        GameHistoryView()
//    }
//}
