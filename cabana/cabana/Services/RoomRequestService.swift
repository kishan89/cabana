//
//  RoomRequestService.swift
//  cabana
//
//  Created by Kishan on 2/8/20.
//  Copyright © 2020 Kishan. All rights reserved.
//

import Firebase
import os

let roomRequestService = RoomRequestService()

class RoomRequestService {
    var db: Firestore
    init() {
        self.db = Firestore.firestore()
    }
    
    func getRoomRequests(completion: @escaping(_ roomRequests: [RoomRequest]) -> Void) {
        var roomRequests = [RoomRequest]()
        // TODO: filter, sort, and limit query
        db.collection("roomRequest").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting roomRequests: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let roomRequest: RoomRequest = RoomRequest(id: document.documentID, data: document.data() as NSDictionary)
                    roomRequests.append(roomRequest)
                }
                completion(roomRequests)
            }
        }
    }
    
    func createRoomRequest() {
        
    }
    
    func fillRoomRequests(_ roomRequests: [RoomRequest], completion: @escaping(_ roomRequests: [RoomRequest], _ error: String?) -> Void) {
        var completedRoomRequests = [RoomRequest]()
        
        var hasFailure: Bool = false
        for roomRequest in roomRequests {
            if (hasFailure) {
                return
            }
            db.collection("roomRequest").document(roomRequest.id)
            .setData([
                "filled"  : true,
                "filledBy": "$userId"
            ], merge: true) { err in
                if let err = err {
                    print("Error filling roomRequest: \(err)")
                    hasFailure = true
                } else {
                    completedRoomRequests.append(roomRequest)
                }
            }
        }
        if (!hasFailure) {
            completion(roomRequests, nil)
        } else {
            // TODO: use firestore bulk update? (to prevent rollback failure)
            // rollback filled requests
            var successfulRollbacks = [RoomRequest]()
            var numAttempts = 0
            while (numAttempts < 3 && successfulRollbacks.count < completedRoomRequests.count) {
                numAttempts += 1
                for completedRoomRequest in completedRoomRequests {
                    db.collection("roomRequest").document(completedRoomRequest.id)
                    .setData([
                        "filled":   false,
                        "filledBy": nil
                    ], merge: true) { (err: Error?) in
                        if let err = err {
                            os_log("action='fill roomRequests' | step='rollback' | message='attempt to rollback failed' |  error='%@' | attemptNumber=%@ | roomRequestId=%@", "\(err)", "\(numAttempts)", completedRoomRequest.id)
                        } else {
                            successfulRollbacks.append(completedRoomRequest)
                        }
                    }
                }
            }
            
            // check if rollback succeeded
            if (successfulRollbacks.count < completedRoomRequests.count) {
                let failedRollbackIds: [String] = completedRoomRequests.map({ $0.id }).filter { successfulRollbacks.map({ $0.id }).contains($0) }
                os_log("action='fill roomRequests' | step='rollback' | message='failed to rollback' | failedRoomRequestIds=%@", "\(failedRollbackIds)")
            }
            completion([], "Failed to fill request for room")
        }
    }
    
    
}
