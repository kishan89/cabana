//
//  VoteService.swift
//  cabana
//
//  Created by Kishan on 12/31/19.
//  Copyright © 2019 Kishan. All rights reserved.
//

import Firebase

let voteService = VoteService()

class VoteService {
    var db: Firestore
    init() {
        self.db = Firestore.firestore()
    }
    
    // MARK: Voting
    func addVote(roomId: String, promptId: String, responseId: String) {
        // should check if all users have voted on the prompt,
        // and make the prompt no longer active if so
        
        // add to 'votes' array and merge new data with existing data
        db.collection("room/\(roomId)/prompt/\(promptId)/response").document(responseId)
            .setData([
                "votes": FieldValue.arrayUnion([userService.getCurrentUserId()])
            ], merge: true) { err in
            if let err = err {
                print("Error adding vote to response: \(err)")
            } else {
                print("New vote successfully added")
            }
        }
    }
    
    func findResponseWithMyVote(roomId: String, promptId: String, completion: @escaping(_ responseId: String?) -> Void) {
        db.collection("room/\(roomId)/prompt/\(promptId)/response")
            .whereField("votes", arrayContains: userService.getCurrentUserId())
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    completion(nil)
                } else {
                    if (querySnapshot!.documents.count > 0) {
                        completion(querySnapshot!.documents[0].documentID)
                    } else {
                        completion(nil)
                    }
                }
        }
    }
    
    func reassignVote(roomId: String, promptId: String, oldResponseId: String, newResponseId: String) {
        db.collection("room/\(roomId)/prompt/\(promptId)/response").document(oldResponseId)
            .setData([
                "votes": FieldValue.arrayRemove([userService.getCurrentUserId()])
            ], merge: true) { err in
            if let err = err {
                print("Error removing vote from response: \(err)")
            } else {
                print("Vote successfully removed")
                self.addVote(roomId: roomId, promptId: promptId, responseId: newResponseId)
            }
        }
    }
}
