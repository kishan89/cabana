//
//  NewResponseView.swift
//  cabana
//
//  Created by Kishan on 10/15/19.
//  Copyright © 2019 Kishan. All rights reserved.
//

import SwiftUI
import Firebase

struct NewResponseView: View {
    @State private var showPopover: Bool = false
    @State private var newResponse: String = ""
    
    var room: Room
    var prompt: Prompt
    
    init(room: Room, prompt: Prompt) {
        self.room = room
        self.prompt = prompt
    }

    var body: some View {
        Button("+") {
            self.showPopover = true
        }.popover(
            isPresented: self.$showPopover,
            arrowEdge: .bottom
        ) {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        let response: Response = Response(data: [
                            "text": self.newResponse,
                            "dateCreated": Timestamp(date: Date())
                        ])
                        responseService.addResponse(roomId: self.room.id, promptId: self.prompt.id, response: response)
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
