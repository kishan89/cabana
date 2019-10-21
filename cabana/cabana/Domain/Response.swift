//
//  Response.swift
//  cabana
//
//  Created by Kishan on 10/12/19.
//  Copyright © 2019 Kishan. All rights reserved.
//

struct Response: Codable, Identifiable {
    var id: String?
    var text: String?
    init(id: String, data: NSDictionary) {
        self.id = id
        self.text = data["text"] as? String
    }
    init(data: NSDictionary) {
        self.text = data["text"] as? String
    }
    func toDict() -> [String : Any] {
        return [
            //TODO: fix so that we only send non-null values to the firestore
            //"id": id,
            "text": text
        ]
    }
}
