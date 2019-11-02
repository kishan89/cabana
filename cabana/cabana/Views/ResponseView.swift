//
//  ResponseView.swift
//  cabana
//
//  Created by Kishan on 10/15/19.
//  Copyright © 2019 Kishan. All rights reserved.
//

import SwiftUI

struct ResponseView: View {
    var response: Response
    init(response: Response) {
        self.response = response
    }
    var body: some View {
        VStack {
            HStack {
                Text("\(Utils.dateString(date: response.dateCreated?.dateValue()))")
                Text("$user")
                Text("\(response.text ?? "n/a")")
                .foregroundColor(Color.white)
                .padding(10)
                .background(Color.blue)
                .cornerRadius(10)
            }
        }
    }
}
