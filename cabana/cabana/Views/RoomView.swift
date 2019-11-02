//
//  RoomView.swift
//  cabana
//
//  Created by Kishan on 10/12/19.
//  Copyright © 2019 Kishan. All rights reserved.
//

import SwiftUI
import Combine
import Firebase
import os

struct RoomView: View {
    var room: Room
    
    @ObservedObject var roomViewModel: RoomViewModel
    
    init(room: Room) {
        self.room = room
        self.roomViewModel = RoomViewModel(room: room)
        
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ForEach(self.roomViewModel.users) { user in
                    Image("pancake").resizable()
                    .clipShape(Circle())
                        .overlay(Circle().stroke(Colors.light, lineWidth: 3))
                        .frame(width: 60, height: 60, alignment: .leading)
                    .padding()
                }
            }
            Text(self.roomViewModel.activePrompt?.text ?? "nil")
                .padding()
            List(roomViewModel.responses) { response in
                ResponseView(response: response)
            }

            if self.roomViewModel.activePrompt != nil {
                NewResponseView(room: self.room, prompt: self.roomViewModel.activePrompt!)
            }
        }
        .navigationBarTitle(Text("\(room.name)"))
        .onAppear {
            self.roomViewModel.load()
        }
        .onDisappear {
             self.roomViewModel.removeListeners()
        }
    }
}

public class RoomViewModel: ObservableObject {
    var room: Room
    var activePrompt: Prompt? = nil {
        didSet {
            objectWillChange.send(self)
        }
    }
    init(room: Room) {
        self.room = room
    }
    public let objectWillChange = PassthroughSubject<RoomViewModel, Never>()
    var responseListener: ListenerRegistration?
    var responses: [Response] = [Response]() {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    var userListener: ListenerRegistration?
    var users: [User] = [User]() {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    func load() {
        os_log("action='loading responses for room' | roomId='$roomId'", log: OSLog.default, type: .info)
        self.responseListener = responseService.listenForResponseChanges(roomId: self.room.id) { responses in
            print("responses have changed")
            self.responses = responses
        }
        self.userListener = userService.listenForUserChanges(roomId: self.room.id) { users in
            print("users have changed")
            self.users = users
        }
        promptService.getActivePromptForRoom(roomId: room.id) { prompt in
            print("prompt: \(prompt?.text ?? "nil")")
            self.activePrompt = prompt
        }
    }
    
    func removeListeners() {
        if let listener = self.responseListener {
            print("destroying response listener")
            listener.remove()
        }
        if let listener = self.userListener {
            print("destroying user listener")
            listener.remove()
        }
    }
}
