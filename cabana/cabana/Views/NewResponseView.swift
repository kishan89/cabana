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
    
    var roomId: String
    var promptId: String
    
    init(roomId: String, promptId: String) {
        self.roomId = roomId
        self.promptId = promptId
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
                        responseService.addResponse(roomId: self.roomId, promptId: self.promptId, response: response)
                        self.showPopover = false
                    }, label: { Text("Submit") })
                   
                }.padding()
                Spacer()
                Text("$prompt")
                TextField("Your response", text: self.$newResponse)
                    .multilineTextAlignment(.center)
                Spacer()
            }
        }
    }
}
