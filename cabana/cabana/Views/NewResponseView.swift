//
//  NewResponseView.swift
//  cabana
//
//  Created by Kishan on 10/15/19.
//  Copyright © 2019 Kishan. All rights reserved.
//

import SwiftUI
import Firebase
import Combine

struct NewResponseView: View {
    @State private var showPopover: Bool = false
    @State private var newResponse: String = ""
    @ObservedObject var newResponseViewModel: NewResponseViewModel
    
    var room: Room
    var prompt: Prompt
    
    init(room: Room, activePrompt: Prompt) {
        self.room = room
        self.prompt = activePrompt
        self.newResponseViewModel = NewResponseViewModel(room: room, activePrompt: activePrompt)
    }

    var body: some View {
        VStack {
            Button("+") {
                self.showPopover = true
            }
            .sheet(
                isPresented: self.$showPopover
            ) {
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            let response: Response = Response(data: [
                                "text": self.newResponse,
                                "dateCreated": Timestamp(date: Date()),
                                "userId": userService.getCurrentUserId()
                            ])
                            responseService.addResponse(roomId: self.room.id, promptId: self.prompt.id, response: response)
                            self.newResponse = ""
                            self.showPopover = false
                        }, label: { Text("Submit") })
                       
                    }.padding()
                    Spacer()
                    Text("\(self.prompt.text)")
                    TextField("Your response", text: self.$newResponse)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
            }
        }
    }
}

public class NewResponseViewModel: ObservableObject {
    var room: Room
    var activePrompt: Prompt
    
    init(room: Room, activePrompt: Prompt) {
        self.room = room
        self.activePrompt = activePrompt
    }
    
    public let objectWillChange = PassthroughSubject<NewResponseViewModel, Never>()
}
