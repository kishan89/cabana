//
//  ResponseService.swift
//  cabana
//
//  Created by Kishan on 10/12/19.
//  Copyright © 2019 Kishan. All rights reserved.
//

import Firebase

let responseService = ResponseService()

class ResponseService {
    var db: Firestore
    init() {
        self.db = Firestore.firestore()
    }
    
    // not used
    func getResponses(roomId: String, completion: @escaping(_ responses: [Response]) -> Void) {
        var responses = [Response]()
        db.collection("room/\(roomId)/prompt/iJK3A4z3FB7iYRDlTHmH/response").getDocuments() { (querySnapshot, err) in
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
        //TODO: order by timestamp
        let listener = db.collection("room/\(roomId)/prompt/iJK3A4z3FB7iYRDlTHmH/response")
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
    
    func addResponse(roomId: String, response: Response) {
        db.collection("room/9NrgXvSuh11xycZcSvAN/prompt/iJK3A4z3FB7iYRDlTHmH/response").document().setData(response.toDict()) { err in
            if let err = err {
                print("Error saving new response: \(err)")
            } else {
                print("New response successfully saved")
            }
        }
    }
}
