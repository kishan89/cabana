//
//  PromptService.swift
//  cabana
//
//  Created by Kishan on 10/26/19.
//  Copyright © 2019 Kishan. All rights reserved.
//

import Firebase

let promptService = PromptService()

class PromptService {
    var db: Firestore
    init() {
        self.db = Firestore.firestore()
    }
    
    // get active prompt for a room
    func getActivePromptForRoom(roomId: String, completion: @escaping (_ prompt: Prompt?) -> Void) -> Void {
        var prompt: Prompt?
        db.collection("room/\(roomId)/prompt")
            .whereField("active", isEqualTo: true)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting prompts: \(err)")
                } else {
                if let docs = querySnapshot?.documents {
                    if (!docs.isEmpty) {
                        if (docs.count > 1) {
                            print("warning: more than one active prompt for room \(roomId)")
                        }
                        prompt = Prompt(id: docs[0].documentID, data: docs[0].data() as NSDictionary)
                    }
                }
                completion(prompt)
            }
        }
    }
    
    func listenForPromptChanges(roomId: String, update: @escaping(_ prompts: [Prompt]) -> ()) -> (ListenerRegistration?) {

        let listener = db.collection("room/\(roomId)/prompt")
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching prompt documents: \(error!)")
                    return
                }
                var prompts = [Prompt]()
                for document in documents {
                    let prompt: Prompt = Prompt(id: document.documentID, data: document.data() as NSDictionary)
                    prompts.append(prompt)
                }
                update(prompts)
            }
        return (listener)
    }
}
