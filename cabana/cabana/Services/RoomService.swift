//
//  RoomService.swift
//  cabana
//
//  Created by Kishan on 10/12/19.
//  Copyright © 2019 Kishan. All rights reserved.
//

import Firebase

let roomService = RoomService()

class RoomService {
    // currently gets all rooms
    func getRooms(userId: String, completion: @escaping (_ rooms: [Room]) -> Void) -> Void {
        let db = Firestore.firestore()

        var rooms = [Room]()
        db.collection("room").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let room: Room = Room(id: document.documentID, data: document.data() as NSDictionary)
                    rooms.append(room)
                }
                completion(rooms)

            }
        }
    }
}

