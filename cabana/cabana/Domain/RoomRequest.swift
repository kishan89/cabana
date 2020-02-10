//
//  RoomRequest.swift
//  cabana
//
//  Created by Kishan on 2/8/20.
//  Copyright © 2020 Kishan. All rights reserved.
//

import Foundation

struct RoomRequest: Identifiable {
    var id: String
    var userId: String?
    var filled: Bool?
    var filledBy: String?
    init(id: String, data: NSDictionary) {
        self.id = id
        self.userId = data["userId"] as? String
        self.filled = data["filled"] as? Bool
        self.filledBy = data["filledBy"] as? String
    }
}
