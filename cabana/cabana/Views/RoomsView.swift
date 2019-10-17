//
//  RoomsView.swift
//  cabana
//
//  Created by Kishan on 10/6/19.
//  Copyright © 2019 Kishan. All rights reserved.
//

import SwiftUI
import Combine

struct RoomsView: View {
    @ObservedObject var roomsViewModel = RoomsViewModel()
    @State private var newResponse: String = ""
    init() {
        self.roomsViewModel.load()
    }
    var body: some View {
        VStack(alignment: .leading) {
            List(roomsViewModel.rooms) { room in
               RoomListItem(room: room)
            }
        }
    }
}

struct RoomListItem: View {
    var room: Room
    init(room: Room) {
        self.room = room
    }
    var body: some View {
        VStack {
            NavigationLink(destination: RoomView(room: room)) {
                Text(room.name)
            }
        }
    }
}

public class RoomsViewModel: ObservableObject {
    public let objectWillChange = PassthroughSubject<RoomsViewModel, Never>()
    var rooms: [Room] = [Room]() {
        didSet {
            print("rooms have been set")
            objectWillChange.send(self)
        }
    }
    func load() {
        roomService.getRooms(userId: "2oNfwEFXqzCHe2dJ3vFG") { rooms in
            self.rooms = rooms
        }
    }
}
