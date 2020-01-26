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
            .popover(
                isPresented: self.$showPopover,
                arrowEdge: .bottom
            ) {
                VStack {
                    VStack(alignment: .trailing) {
                        Button("Done") {
                            self.showPopover = false
                        }
                    }
                    
                    Text("Active Prompt:")
                    Text(self.activePrompt.text)
                        .padding()
                    List(self.activePromptViewModel.responses) { response in
                        ResponseView(room: self.room, prompt: self.activePrompt, response: response)
                    }
                    if(self.activePromptViewModel.canSubmitResponse) {
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

// MARK: View Model
public class ActivePromptViewModel: ObservableObject {
    public let objectWillChange = PassthroughSubject<ActivePromptViewModel, Never>()
    var room: Room
    var activePrompt: Prompt
    var activePromptListener: ListenerRegistration?
    
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
                    self.checkIfUserCanSubmitResponse()
                    
                    if self.allUsersHaveResponded() && self.allUsersHaveVoted() {
                        promptService.setPromptInactive(roomId: self.room.id, promptId: self.activePrompt.id)
                    }
                }
            }
            // only check if prompt should be active after 1st user registration,
            // because for 1st registration the response listener will handle that
            // (avoids double call to method)
            if self.userChangesCount > 1 && self.allUsersHaveResponded() && self.allUsersHaveVoted() {
                promptService.setPromptInactive(roomId: self.room.id, promptId: self.activePrompt.id)
            }
        }
    }
    
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
    
    func checkIfUserCanSubmitResponse() {
        //TEMP (for testing)
        self.canSubmitResponse = true
        return
        //END TEMP
        
        if (activePrompt.userId == userService.getCurrentUserId()) {
            self.canSubmitResponse = false
            return
        }
        responseService.userSubmittedResponse(roomId: room.id, promptId: activePrompt.id) { responseFound in
            print("responseFound: \(responseFound)")
            self.canSubmitResponse = !responseFound
        }
    }
    
    func removeListener() {
        if let listener = self.responseListener {
            print("destroying response listener for active prompt in room")
            listener.remove()
        }
    }
}
