//
//  UserService.swift
//  cabana
//
//  Created by Kishan on 10/20/19.
//  Copyright © 2019 Kishan. All rights reserved.
//

import Firebase

let userService = UserService()

class UserService {
    var db: Firestore
    init() {
        self.db = Firestore.firestore()
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
    
    func getUsersForRoom(roomId: String, completion: @escaping(_ users: [User]) -> Void) {
        var users = [User]()
        db.collection("users").whereField("roomIds", arrayContains: roomId).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let user: User = User(id: document.documentID, data: document.data() as NSDictionary)
                    users.append(user)
                }
                completion(users)
            }
        }
    }
    
    func getCurrentUserId() -> String {
        return "2oNfwEFXqzCHe2dJ3vFG"
    }
    
    func getUsername(userId: String?) -> String {
        return userId ?? "Unknown"
    }
}
