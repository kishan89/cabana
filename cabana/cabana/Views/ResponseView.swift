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
    var viewState: ViewState
    var hasMyVote: Bool = false
    var responseViewModel: ResponseViewModel
    
    init(room: Room, prompt: Prompt, response: Response, viewState: ViewState) {
        self.response = response
        self.room = room
        self.prompt = prompt
        self.viewState = viewState
        self.responseViewModel = ResponseViewModel(room: room, prompt: prompt, response: response)
        if (self.response.votes.contains(userService.getCurrentUserId())) {
            self.hasMyVote = true
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if (self.viewState == .completed) {
                Text(userService.getUsername(userId: response.userId))
                    .padding(.bottom, 2)
            }
            HStack {
                Text("\(response.text ?? "n/a")")
                    .foregroundColor(self.hasMyVote && self.viewState == .vote ? Color.white : Color.purple) // TODO: use @State colors for transitions
                .padding(6)
                    .background(self.hasMyVote && self.viewState == .vote ? Color.purple : Color.clear)
                    .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.purple, lineWidth: 3)
                )
                if (self.viewState == .completed) {
                    Text("\(response.votes.count)")
                    .bold()
                    .padding(6)
                }
            }
        }.onTapGesture {
            if (self.viewState == .vote) {
                self.responseViewModel.addOrReassignVote()
            }
        }
    }
}

struct ResponseView_Previews: PreviewProvider {
    static var previews: some View {
        let room = Room(id: "r1", data: ["name": "Test Room", "userIds": ["user1", "user2"]])
        let prompt = Prompt(id: "p1", data: ["text": "Test Prompt", "userId": "user2", "active": true])
        let response = Response(id: "resp1", data: ["text": "Test Response", "userId": "user1", "votes": [userService.getCurrentUserId()]])
        let viewState: ViewState = .completed
        let responseView = ResponseView(room: room, prompt: prompt, response: response, viewState: viewState)
        return responseView
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
