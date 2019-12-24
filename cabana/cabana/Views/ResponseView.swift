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
    var room: Room
    var prompt: Prompt
    init(room: Room, prompt: Prompt, response: Response) {
        self.response = response
        self.room = room
        self.prompt = prompt
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
                Text("\(response.votes.count)")
            }
        }.onTapGesture {
            responseService.addVote(roomId: self.room.id, promptId: self.prompt.id, responseId: self.response.id!)
        }
    }
}
