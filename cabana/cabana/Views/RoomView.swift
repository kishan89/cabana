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
    init(room: Room) {
        self.room = room
    }
    var body: some View {
        VStack {
            List(roomViewModel.responses) { response in
               ResponseView(response: response)
            }
        }
        .navigationBarTitle(Text("\(room.name)"))
        .onAppear {
            // TODO: unregister listener when view is destroyed
            self.roomViewModel.load()
        }
    }
}

struct ResponseView: View {
    var response: Response
    init(response: Response) {
        self.response = response
    }
    var body: some View {
        VStack {
            Text("\(response.text ?? "n/a")")
        }
    }
}

public class RoomViewModel: ObservableObject {
    public let objectWillChange = PassthroughSubject<RoomViewModel, Never>()
    var responses: [Response] = [Response]() {
        didSet {
            objectWillChange.send(self)
        }
    }
    func load() {
        print("load")
        responseService.listenForResponseChanges(roomId: "9NrgXvSuh11xycZcSvAN") { responses in
            print("responses have changed")
            self.responses = responses
        }
    }
}
