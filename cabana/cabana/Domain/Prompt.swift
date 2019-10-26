//
//  Prompt.swift
//  cabana
//
//  Created by Kishan on 10/26/19.
//  Copyright © 2019 Kishan. All rights reserved.
//

struct Prompt: Codable, Identifiable {
    var id: String
    var text: String
    var userId: String
    init(id: String, data: NSDictionary) {
        self.id = id
        self.text = data["text"] as? String ?? ""
        self.userId = data["userId"] as? String ?? ""
    }
}
