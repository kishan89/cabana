//
//  DbObjects.swift
//  cabana
//
//  Created by Kishan on 10/6/19.
//  Copyright © 2019 Kishan. All rights reserved.
//

import Foundation

struct Room: Codable, Identifiable {
    var id: String
    var name: String?
    init(id: String, data: NSDictionary) {
        self.id = id
        self.name = data["name"] as? String
    }
}
