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
    init(id: String, data: NSDictionary) {
        self.id = id
        self.text = data["text"] as? String
        self.dateCreated = data["dateCreated"] as? Timestamp
    }
    init(data: NSDictionary) {
        self.text = data["text"] as? String
        self.dateCreated = data["dateCreated"] as? Timestamp
    }
    func toDict() -> [String : Any] {
        return [
            //TODO: fix so that we only send non-null values to the firestore
            //"id": id,
            "text": text,
            "dateCreated": dateCreated
        ]
    }
}
