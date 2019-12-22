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
    @ObservedObject var activePromptViewModel: ActivePromptViewModel
    init(room: Room, activePrompt: Prompt) {
        self.room = room
        self.activePrompt = activePrompt
        self.activePromptViewModel = ActivePromptViewModel(room: room, activePrompt: activePrompt)
    }
    var body: some View {
        VStack {
            Text(self.activePrompt.text)
                .padding()
            List(activePromptViewModel.responses) { response in
                ResponseView(response: response)
            }
            NewResponseView(room: self.room, prompt: self.activePrompt)
        }
        .onAppear {
            self.activePromptViewModel.load()
        }
        .onDisappear {
            self.activePromptViewModel.removeListener()
        }
    }
}

public class ActivePromptViewModel: ObservableObject {
    var room: Room
    var activePrompt: Prompt
    init(room: Room, activePrompt: Prompt) {
        self.room = room
        self.activePrompt = activePrompt
    }
    
    public let objectWillChange = PassthroughSubject<ActivePromptViewModel, Never>()
    var responseListener: ListenerRegistration?
    var responses: [Response] = [Response]() {
        didSet {
            print("did set responses")
            objectWillChange.send(self)
        }
    }
    
    func load() {
        os_log("action='adding response listener for active prompt' | roomId='$roomId'", log: OSLog.default, type: .info)
        self.responseListener = responseService.listenForResponseChanges(roomId: self.room.id, promptId: self.activePrompt.id) { responses in
            print("responses have changed: \(responses)")
            self.responses = responses
        }
    }
    
    func removeListener() {
        if let listener = self.responseListener {
            print("destroying response listener for active prompt in room")
            listener.remove()
        }
    }
}
