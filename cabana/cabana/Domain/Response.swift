//
//  Response.swift
//  cabana
//
//  Created by Kishan on 10/12/19.
//  Copyright © 2019 Kishan. All rights reserved.
//
import Firebase

struct Response: Identifiable {
    var id: String?
    var text: String?
    var dateCreated: Timestamp?
    var userId: String?
    var votes: Array<String>
    
    init(id: String, data: NSDictionary) {
        self.id = id
        self.text = data["text"] as? String
        self.dateCreated = data["dateCreated"] as? Timestamp
        self.userId = data["userId"] as? String
        self.votes = data["votes"] as? Array<String> ?? [String]()
    }
    init(data: NSDictionary) {
        self.text = data["text"] as? String
        self.dateCreated = data["dateCreated"] as? Timestamp
        self.userId = data["userId"] as? String
        self.votes = data["votes"] as? Array<String> ?? [String]()
    }
    func toDict() -> [String : Any] {
        return [
            //TODO: fix so that we only send non-null values to the firestore
            //"id": id,
            "text": text,
            "dateCreated": dateCreated,
            "userId": userId,
            "votes": votes
        ]
    }
}
