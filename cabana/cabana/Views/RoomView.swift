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

struct RoomView: View {
    var room: Room
    @ObservedObject var roomViewModel = RoomViewModel()
    
    @State private var showPopover: Bool = false
    
    init(room: Room) {
        self.room = room
    }
    var body: some View {
        VStack {
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
             self.roomViewModel.removeListener()
        }
    }
}

public class RoomViewModel: ObservableObject {
    public let objectWillChange = PassthroughSubject<RoomViewModel, Never>()
    var listener: ListenerRegistration?
    
    var responses: [Response] = [Response]() {
        didSet {
            objectWillChange.send(self)
        }
    }
    func load() {
        print("load")
        self.listener = responseService.listenForResponseChanges(roomId: "9NrgXvSuh11xycZcSvAN") { responses in
            print("responses have changed")
            self.responses = responses
        }
    }
    
    func removeListener() {
        if let listener = self.listener {
            print("destroying listener")
            listener.remove()
        }
    }
}
