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
    
    @ObservedObject var roomViewModel = RoomViewModel()
    @State private var showPopover: Bool = false
    
    init(room: Room) {
        self.room = room
    }
    var body: some View {
        VStack {
            HStack {
                ForEach(self.roomViewModel.users) { user in
                    Image("pancake").resizable()
                    .clipShape(Circle())
                        .overlay(Circle().stroke(Colors.light, lineWidth: 3))
                        .frame(width: 60, height: 60, alignment: .leading)
                    .padding()
                }
            }
            //TODO: add prompt
            Text("n/a")
                .padding()
            List(roomViewModel.responses) { response in
                ResponseView(response: response)
            }
            Button("+") {
                self.showPopover = true
            }.popover(
                isPresented: self.$showPopover,
                arrowEdge: .bottom
            ) {
                NewResponseView(showPopover: self.$showPopover)
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
    //var room: Room
    //init(room: Room) {
    //    self.room = room
    //}
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
        os_log("action='loading responses for room' | roomId='9NrgXvSuh11xycZcSvAN'", log: OSLog.default, type: .info)
        self.responseListener = responseService.listenForResponseChanges(roomId: "9NrgXvSuh11xycZcSvAN") { responses in
            print("responses have changed")
            self.responses = responses
        }
        self.userListener = userService.listenForUserChanges(roomId: "9NrgXvSuh11xycZcSvAN") { users in
            print("users have changed")
            self.users = users
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
