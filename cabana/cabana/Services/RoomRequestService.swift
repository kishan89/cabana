//
//  RoomRequestService.swift
//  cabana
//
//  Created by Kishan on 1/26/20.
//  Copyright © 2020 Kishan. All rights reserved.
//

import Firebase

let roomRequestService = RoomRequestService()

class RoomRequestService {
    var db: Firestore
    init() {
        self.db = Firestore.firestore()
    }
    
    func listenForRoomRequestChanges(update: @escaping(_ roomRequests: [RoomRequest]) -> ()) {
        
    }
    func listenForUserChanges(roomId: String, update: @escaping(_ users: [User]) -> ()) -> (ListenerRegistration?) {
        //TODO: order by timestamp
        let listener = db.collection("users")
            .whereField("roomIds", arrayContains: roomId)
        .addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching response documents: \(error!)")
                return
            }
            var users = [User]()
            for document in documents {
                let user: User = User(id: document.documentID, data: document.data() as NSDictionary)
                users.append(user)
            }
            print(users)
            update(users)
        }
        return (listener)
    }
}
