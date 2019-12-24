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
            // TODO: add inactive prompt views
            
            if self.roomViewModel.activePrompt != nil {
                Divider()
                ActivePromptView(room: self.room, activePrompt: self.roomViewModel.activePrompt!)
            }
        }
        .navigationBarTitle(Text("\(room.name)"))
        .onAppear {
            self.roomViewModel.load()
        }
        .onDisappear {
            self.roomViewModel.activePrompt = nil
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
    
    var userListener: ListenerRegistration?
    var users: [User] = [User]() {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    func load() {
        userService.getUsersForRoom(roomId: self.room.id) { users in
            self.users = users
            print("users: \(self.users)")
            // TODO: figure out why active prompt must be fetched after users are fetched
            promptService.getActivePromptForRoom(roomId: self.room.id) { prompt in
                print("active prompt: \(prompt?.text ?? "nil")")
                self.activePrompt = prompt
            }
        }
    }
}
