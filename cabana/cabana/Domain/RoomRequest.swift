//
//  RoomRequest.swift
//  cabana
//
//  Created by Kishan on 1/26/20.
//  Copyright © 2020 Kishan. All rights reserved.
//

import Foundation

struct RoomRequest: Identifiable {
    var id: String
    var userId: String
    init(id: String, data: NSDictionary) {
        self.id = id
        self.userId = data["userId"] as? String ?? ""
    }
}
