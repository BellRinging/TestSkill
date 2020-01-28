//
//  ChatDetailViewModel.swift
//  QBChat-MVVM
//
//  Created by Paul Kraft on 30.10.19.
//  Copyright © 2019 QuickBird Studios. All rights reserved.
//

import Foundation




class RegisterViewModel: ObservableObject {
  
    

//    @Published
    private(set) var state: RegisterViewState
//
//    private let chatService: ChatService
//
//    private let chat: Chat

//    init(chat: Chat, chatService: Any) {
    init() {
//        self.chatService = chatService
//        self.chat = chat
//        self.state = ChatDetailState(chat: chat,
//                                     currentUser: chatService.currentUser,
//                                     messages: [])
        self.state = RegisterViewState(email:"",password: "")
    }


    func trigger(_ input: Any) {
//        switch input {
//        case .addMessage(let message):
//            chatService.addMessage(message, to: chat)
//            self.state.messages = fetchMessages()
//        }
    }

}
