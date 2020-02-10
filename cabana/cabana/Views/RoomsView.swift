//
//  RoomsView.swift
//  cabana
//
//  Created by Kishan on 10/6/19.
//  Copyright © 2019 Kishan. All rights reserved.
//

import SwiftUI
import Combine
import os

struct RoomsView: View {
    @ObservedObject var roomsViewModel = RoomsViewModel()
    @State private var newResponse: String = ""
    init() {
        UITableView.appearance().separatorColor = .clear
        self.roomsViewModel.load()
    }
    var body: some View {
        VStack(alignment: .leading) {
            NewRoomView(userId: self.roomsViewModel.userId)
            List(roomsViewModel.rooms) { room in
               RoomListItem(room: room)
                // TODO: make width dynamic
                .frame(width: 300, height: 80, alignment: .center)
                .background(Colors.dark)
                .cornerRadius(20)
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
        VStack(alignment: .leading) {
            Text("\(room.name)")//(UIColor(red: 234, green: 222, blue: 218, alpha: 1))
                .padding()
                .foregroundColor(Colors.light)
            NavigationLink(destination: RoomView(room: room), label: {
                EmptyView()
            })
        }
        
    }
}

public class RoomsViewModel: ObservableObject {
    var userId: String = "2oNfwEFXqzCHe2dJ3vFG"
    public let objectWillChange = PassthroughSubject<RoomsViewModel, Never>()
    var rooms: [Room] = [Room]() {
        didSet {
            os_log("rooms have been set | count=%@", "\(rooms.count)")
            objectWillChange.send(self)
        }
    }
    func load() {
        roomService.getRooms(userId: userId) { rooms in
            self.rooms = rooms
        }
    }
}

//struct RoomsView_Previews : PreviewProvider {
//    static var previews: some View {
//        RoomsView()
//    }
//}

//struct RoomListItem_Previews : PreviewProvider {
//    static var previews: some View {
//        RoomListItem(room: Room(id: "1", data: ["name": "name1"]))
//    }
//}
