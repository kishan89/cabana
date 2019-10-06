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
    init() {
        self.roomsViewModel.load()
    }
    var body: some View {
        VStack(alignment: .leading) {
            Text("Your Rooms")
                .bold()
                .font(.largeTitle)
                .padding()
            List(roomsViewModel.rooms) { room in
               RoomView(room: room)
            }
        }
    }
}

struct RoomView: View {
    var room: Room
    init(room: Room) {
        self.room = room
    }
    var body: some View {
        VStack {
            Text(room.name!)
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
        DbUtils.getRooms() { rooms in
            self.rooms = rooms
        }
    }
}
