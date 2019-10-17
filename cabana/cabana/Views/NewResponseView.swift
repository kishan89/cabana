//
//  NewResponseView.swift
//  cabana
//
//  Created by Kishan on 10/15/19.
//  Copyright © 2019 Kishan. All rights reserved.
//

import SwiftUI

struct NewResponseView: View {
    @Binding var showPopover: Bool
    @State private var newResponse: String = ""

    var body: some View {
        //TODO: move popover to new file
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    responseService.addResponse(roomId: "9NrgXvSuh11xycZcSvAN", text: self.newResponse)
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
