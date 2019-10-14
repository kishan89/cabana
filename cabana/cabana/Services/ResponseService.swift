//
//  ResponseService.swift
//  cabana
//
//  Created by Kishan on 10/12/19.
//  Copyright © 2019 Kishan. All rights reserved.
//

import Firebase
// import Logging

let responseService = ResponseService()

class ResponseService {
    var db: Firestore
    init() {
        self.db = Firestore.firestore()
    }
    
    func getResponses(roomId: String, completion: @escaping(_ responses: [Response]) -> Void) {
        var responses = [Response]()
        db.collection("room/\(roomId)/response").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let response: Response = Response(id: document.documentID, data: document.data() as NSDictionary)
                    responses.append(response)
                }
                completion(responses)
            }
        }
    }
    
    func listenForResponseChanges(roomId: String, update: @escaping(_ responses: [Response]) -> ()) -> (ListenerRegistration?) {
        let listener = db.collection("room/\(roomId)/response")
        .addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching response documents: \(error!)")
                return
            }
            var responses = [Response]()
            for document in documents {
                let response: Response = Response(id: document.documentID, data: document.data() as NSDictionary)
                responses.append(response)
            }
            update(responses)
        }
        return (listener)
    }
}
