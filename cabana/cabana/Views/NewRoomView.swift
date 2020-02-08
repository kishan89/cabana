//
//  NewRoomView.swift
//  cabana
//
//  Created by Kishan on 10/19/19.
//  Copyright © 2019 Kishan. All rights reserved.
//

import SwiftUI

struct NewRoomView: View {
    @State private var showPopover: Bool = false
    
    var body: some View {
        VStack {
            Button("new") {
                self.showPopover = true
            }
            .sheet(isPresented: self.$showPopover) {
                Button(action: {
                    self.showPopover = false
                }, label: { Text("Done") })
                    
                Spacer()
                Text("Hello World!")
            }
            
        }
    }
}

//struct NewRoomView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewRoomView()
//    }
//}
