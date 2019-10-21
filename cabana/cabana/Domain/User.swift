//
//  User.swift
//  cabana
//
//  Created by Kishan on 10/20/19.
//  Copyright © 2019 Kishan. All rights reserved.
//

struct User: Identifiable {
    var id: String
    var name: String
    init(id: String, data: NSDictionary) {
        self.id = id
        self.name = data["name"] as? String ?? ""
    }
}
