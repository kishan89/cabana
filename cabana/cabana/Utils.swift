//
//  Utils.swift
//  cabana
//
//  Created by Kishan on 11/2/19.
//  Copyright © 2019 Kishan. All rights reserved.
//

import Foundation

class Utils {
    static func dateString(date: Date?) -> String {
        if let date = date {
            let df = DateFormatter()
            df.dateFormat =  "yyyy-MM-dd hh:mm:ss"
            return df.string(from: date)
        }
        return ""
    }
}
