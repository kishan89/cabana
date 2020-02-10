//
//  NewRoomView.swift
//  cabana
//
//  Created by Kishan on 10/19/19.
//  Copyright © 2019 Kishan. All rights reserved.
//

import SwiftUI
import Combine
import os

struct NewRoomView: View {
    @State private var showPopover: Bool = false
    @ObservedObject var newRoomViewModel: NewRoomViewModel
    var userId: String
    
    init(userId: String) {
        self.userId = userId
        self.newRoomViewModel = NewRoomViewModel()
    }
    
    var body: some View {
        VStack {
            Button("new") {
                // display pending roomRequests for this user
                
                self.showPopover = true
            }
            .sheet(isPresented: self.$showPopover) {
                VStack {
                    Button(action: {
                        self.showPopover = false
                    }, label: { Text("Done") })
                    if (!self.newRoomViewModel.isSearching) {
                        Button("search for game") {
                            self.newRoomViewModel.searchForRooms()
                        }
                    } else {
                        Text("searching for game...")
                    }
                    
                    Spacer()
                    Text("Hello World!")
                }
                .onAppear {
                    
                }
                .onDisappear {
                    self.newRoomViewModel.reset()
                }
                
            }
        }
    }
}

public class NewRoomViewModel: ObservableObject {
    public let objectWillChange = PassthroughSubject<NewRoomViewModel, Never>()
    var isSearching: Bool = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    var roomRequests = [RoomRequest]() {
        didSet {
            // check if enough roomRequests and they meet criteria for a room
            // ^^ (actually do this in the search method)
                
            // try to update roomRequests to filled = true
            // roomRequestService.fillRoomRequests(self.roomRequests) { roomRequests, error in }
            
            //  if successful: create room
            //  else: tell the user there was an error
        }
    }
    
    init() {
        
    }
    
    func searchForRooms() {
        // only search for rooms if the user doesn't already having 1 (or more?) pending roomRequests
        os_log("searching for game...")
        isSearching = true
        searchForRoomRequests(attemptNumber: 0)
    }
  
    func searchForRoomRequests(attemptNumber: Int) {
        os_log("action='searchForRoomRequests' | attemptNumber=%@", "\(attemptNumber)")
        if (attemptNumber >= 3) {
            os_log("action='searchForRoomRequests' | message='could not find enough roomRequests' | count=%@", "\(roomRequests.count)")

            // create roomRequest for user and wait for it to be filled (or create on view load)?
            self.isSearching = false
            return
        }

        roomRequestService.getRoomRequests() { roomRequests in
            if (roomRequests.count > 0) {
                os_log("action='searchForRoomRequests' | message='found roomRequests' | count=%@", "\(roomRequests.count)")
                self.roomRequests = roomRequests
            } else {
                do {
                    sleep(2)
                }
                let newAttemptNumber = attemptNumber + 1
                self.searchForRoomRequests(attemptNumber: newAttemptNumber)
            }
        }
        
    }
    
    func reset() {
        os_log("stopped searching for game")
        isSearching = false
    }
}

//struct NewRoomView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewRoomView()
//    }
//}
