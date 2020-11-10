////
////  ListPagination.swift
////  ListPaginationSwiftUI2
////
////  Created by projas on 5/29/20.
////  Copyright © 2020 Pedro Rojas. All rights reserved.
////
//
//import SwiftUI
//
//public struct ListPagination<Content>: View where Content : View {
//  
//    private var games:  [String:[Game]]
//    var content: (_ item: Game) -> Content
//    var headerContent: (_ header: String) -> Content
//    var pagination: ((() -> Void)?) -> Void
//    @State var isLoading = false
//    var sectionHeader : [String] = []
//    private var offset: Int
//  
//  init (games: [String:[Game]], offset: Int = 1, pagination: @escaping (_ completion: (() -> Void)?) -> Void, @ViewBuilder
//    headerContent: @escaping (_ header: String) -> Content,@ViewBuilder content: @escaping (_ game: Game) -> Content) {
//    self.games =  games
//    self.content = content
//    self.headerContent = headerContent
//    self.pagination = pagination
//    self.offset = offset
//    self.sectionHeader = games.keys.map{$0}
//  }
//  
//    public var body: some View {
//        List {
//            ForEach(sectionHeader, id: \.self) { period in
//                Section(header: self.headerContent(period)) {
//                    ForEach(self.games[period]!.indices ) { index in
//                        VStack {
//                            self.content(self.games[period]![index])
//                            if self.isLoading && self.isLastItem(period: period , index: index) {
//                                HStack(alignment: .center) {
//                                    SpinnerView(isAnimating: self.$isLoading, style: .medium)
//                                }
//                            }
//                        }.onAppear {
//                            self.itemAppears(period: period , index: index)
//                        }
//                    }
//                }
//            }
//        }
//    }
//    
//    
//    func isLastItem(period : String , index: Int) -> Bool {
//        if sectionHeader.count > 0 {
//             return period == sectionHeader[sectionHeader.count-1] && index == (games[period]!.count - 1)
//        }else {
//            return false
//        }
//       
//     }
//     
//    func isOffsetReached(period:String , index : Int) -> Bool {
//        if sectionHeader.count > 0 {
//             return period == sectionHeader[sectionHeader.count-1] && index == (games[period]!.count - offset)
//        }else {
//            return false
//        }
//     }
//     
//     func itemAppears(period:String , index : Int) {
//       if isOffsetReached(period:period , index : index) {
//         isLoading = true
//         pagination {
//           self.isLoading = false
//         }
//       }
//     }
//}
//
//
