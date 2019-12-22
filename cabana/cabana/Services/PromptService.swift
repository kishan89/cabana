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
    // get active prompt for a room
    func getActivePromptForRoom(roomId: String, completion: @escaping (_ prompt: Prompt?) -> Void) -> Void {
        let db = Firestore.firestore()

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
}
