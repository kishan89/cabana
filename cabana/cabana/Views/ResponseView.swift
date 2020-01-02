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
    var responseViewModel: ResponseViewModel
    init(room: Room, prompt: Prompt, response: Response) {
        self.response = response
        self.room = room
        self.prompt = prompt
        self.responseViewModel = ResponseViewModel(room: room, prompt: prompt, response: response)
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
            self.responseViewModel.addOrReassignVote()
        }
    }
}

public class ResponseViewModel: ObservableObject {
    var response: Response
    var room: Room
    var prompt: Prompt
    init(room: Room, prompt: Prompt, response: Response) {
        self.response = response
        self.room = room
        self.prompt = prompt
    }
    
    func addOrReassignVote() {
        voteService.findResponseWithMyVote(roomId: room.id, promptId: prompt.id) { responseId in
            if (responseId != nil) {
                if (responseId! == self.response.id!) {
                    return
                }
                // reassign vote
                voteService.reassignVote(roomId: self.room.id, promptId: self.prompt.id, oldResponseId: responseId!, newResponseId: self.response.id!)
                print("found response with my vote, \(responseId)")
            } else {
                voteService.addVote(roomId: self.room.id, promptId: self.prompt.id, responseId: self.response.id!)
            }
        }
    }
}
