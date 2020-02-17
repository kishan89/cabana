//
//  ActivePromptView.swift
//  cabana
//
//  Created by Kishan on 11/2/19.
//  Copyright © 2019 Kishan. All rights reserved.
//

import SwiftUI
import Combine
import Firebase
import os

struct ActivePromptView: View {
    var room: Room
    var activePrompt: Prompt
    @State private var showPopover: Bool = false
    @ObservedObject var activePromptViewModel: ActivePromptViewModel
    
    init(room: Room, activePrompt: Prompt) {
        self.room = room
        self.activePrompt = activePrompt
        self.activePromptViewModel = ActivePromptViewModel(room: room, activePrompt: activePrompt)
    }
    var body: some View {
        VStack {
            Text("Active Prompt:")
            Button(self.activePrompt.text) {
                self.showPopover = true
            }
            .sheet(
                isPresented: self.$showPopover
            ) {
                VStack(alignment: .leading) {
                    VStack(alignment: .trailing) {
                        Button("Done") {
                            self.showPopover = false
                        }
                    }
                    .padding()
                    
                    Text(self.activePrompt.text)
                        .bold()
                        .padding()
                    List(self.activePromptViewModel.responses) { response in
                        ResponseView(room: self.room, prompt: self.activePrompt, response: response, viewState: self.activePromptViewModel.viewState)
                    }
                    if(self.activePromptViewModel.viewState == .respond) {
                        NewResponseView(room: self.room, activePrompt: self.activePrompt)
                    }
                }
                .onAppear {
                    print("active prompt appearing..")
                    self.activePromptViewModel.load()
                }
                .onDisappear {
                    self.activePromptViewModel.removeListener()
                }
            }
        }
    }
}

struct ActivePromptView_Previews: PreviewProvider {
    static var previews: some View {
        let room = Room(id: "r1", data: ["name": "Test Room", "userIds": ["user1", "user2"]])
        let prompt = Prompt(id: "p1", data: ["text": "Test Prompt", "userId": "user2", "active": true])
        let activePromptView = ActivePromptView(room: room, activePrompt: prompt)
        return activePromptView
    }
}

// MARK: View Model
public class ActivePromptViewModel: ObservableObject {
    public let objectWillChange = PassthroughSubject<ActivePromptViewModel, Never>()
    var room: Room
    var activePrompt: Prompt
    var activePromptListener: ListenerRegistration?

    var viewState: ViewState = .unknown { didSet {
        objectWillChange.send(self)
        os_log("action='set viewState' | viewState='%@'", "\(viewState)")
    } }
    
    init(room: Room, activePrompt: Prompt) {
        self.room = room
        self.activePrompt = activePrompt
    }
    
    var canSubmitResponse: Bool = false {
        didSet {
            print("did set canSubmitResponse: \(canSubmitResponse)")
            objectWillChange.send(self)
        }
    }

    var responseListener: ListenerRegistration?
    var responses: [Response] = [Response]() {
        didSet {
            print("did set/change responses")
            objectWillChange.send(self)
        }
    }
    
    var userListener: ListenerRegistration?
    var users: [User] = [User]() {
        didSet {
            print("did set/change users")
            objectWillChange.send(self)
        }
    }
    
    var userChangesCount: Int = 0
    func load() {
        userChangesCount = 0
        os_log("action='adding response and user listener for active prompt' | roomId='$roomId'", log: OSLog.default, type: .info)
        
        self.userListener = userService.listenForUserChanges(roomId: self.room.id) { users in
            self.userChangesCount += 1
            print("users have changed: \(users.map({$0.id}))")
            self.users = users
            
            //only register the response listener once && after the users are populated
            if (self.userChangesCount == 1) {
                self.responseListener = responseService.listenForResponseChanges(roomId: self.room.id, promptId: self.activePrompt.id) { responses in
                    print("responses have changed: \(responses.map({$0.id}))")
                    self.responses = responses
                    self.updateViewState()
                }
            }
            // only check if prompt should be active after 1st user registration,
            // because for 1st registration the response listener will handle that
            // (avoids double call to method)
            if self.userChangesCount > 1 {
                self.updateViewState()
            }
        }
    }
    
    func updateViewState() {
        if activePrompt.userId == userService.getCurrentUserId() {
            // user created the prompt
            viewState = .standby
            return
        }
        if !self.allUsersHaveResponded() {
            if self.responses.first(where: { $0.userId == userService.getCurrentUserId() }) == nil {
                viewState = .respond
            } else {
                viewState = .responding
            }
        } else if !allUsersHaveVoted() {
            viewState = .vote
        } else {
            viewState = .completed
            promptService.setPromptInactive(roomId: self.room.id, promptId: self.activePrompt.id)
        }
    }
    
    // TODO: move to a service (PromptService?)
    func allUsersHaveVoted() -> Bool {
        let uniqueUsers: Set = Set(self.users.map({ $0.id }))
        var uniqueVotes: Set = Set<String>()
    
        for response in self.responses {
            for vote in response.votes {
                uniqueVotes.insert(vote)
            }
        }
        print("all users have voted: \(uniqueUsers == uniqueVotes)")
        return uniqueUsers == uniqueVotes
    }
    
    func allUsersHaveResponded() -> Bool {
        let uniqueUsers: Set = Set(self.users.map({ $0.id }))
        let uniqueResponses: Set = Set(self.responses.compactMap({ $0.userId ?? nil }))
        print("all users have responded: \(uniqueUsers == uniqueResponses)")
        return uniqueUsers == uniqueResponses
    }
    
    func removeListener() {
        if let listener = self.responseListener {
            print("destroying response listener for active prompt in room")
            listener.remove()
        }
        if let listener = self.userListener {
            print("destroying user listener for active prompt in room")
            listener.remove()
        }
    }
}

// MARK: enums
enum ViewState {
    case standby // iff user created the prompt
    case respond // user needs to respond
    case responding // others need to respond
    case vote // user needs to vote
    case voting // others need to vote (NOTE: this state is not currently used)
    case completed
    case unknown // initial state
}
