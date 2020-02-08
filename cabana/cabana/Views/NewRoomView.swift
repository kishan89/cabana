//
//  NewRoomView.swift
//  cabana
//
//  Created by Kishan on 10/19/19.
//  Copyright © 2019 Kishan. All rights reserved.
//

import SwiftUI
import Firebase
import Combine

struct NewRoomView: View {
    @State private var showPopover: Bool = false
    @ObservedObject var newRoomViewModel: NewRoomViewModel
    
    init() {
        self.newRoomViewModel = NewRoomViewModel()
    }
    var body: some View {
        MatchmakingView([self])
//        Button("new") {
//            self.showPopover = true
//            // add RoomRequest listener
//        }.sheet(
//            isPresented: self.$showPopover
//        ) {
//                MatchmakingView([self])
////                Button(action: {
////                    self.showPopover = false
////                }, label: { Text("Done") })
////
////                Text("searching for rooms...")
            .onAppear {
                self.newRoomViewModel.load()
            }
            .onDisappear {
                self.newRoomViewModel.removeListeners()
            }
//        }
    }
}

public class NewRoomViewModel: ObservableObject {
    public let objectWillChange = PassthroughSubject<NewRoomViewModel, Never>()
    var roomRequestListener: ListenerRegistration?
    var roomRequests = [RoomRequest]() {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    func load() {
        // TODO: USE GAME CENTER MATCHING!
        roomRequestService.listenForRoomRequestChanges() { roomRequests in
            print("roomRequests in, \(roomRequests)")
            //check if we can create a Room
            if (roomRequests.count >= 5) {
                // lock these 5 users from being used for a different room..
                
                //option 1:
                // create/save a RoomReady object
                // add these users
                // wait 2 seconds, confirm no other RoomReady objects exist with any of these users
                // if no other RoomReady objects exist for users:
                //   - create Room
                //   - delete RoomReady object
                // else:
                //   - delete RoomReady object
                //   - wait 3 seconds
                //   - continue listening from RoomRequest changes
            }
        }
    }
    
    func removeListeners() {
        if let listener = roomRequestListener {
            listener.remove()
        }
    }
}

//struct NewRoomView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewRoomView()
//    }
//}
