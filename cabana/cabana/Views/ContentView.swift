//
//  ContentView.swift
//  cabana
//
//  Created by Kishan on 9/29/19.
//  Copyright © 2019 Kishan. All rights reserved.
//

import SwiftUI
import FacebookLogin

struct ContentView: View {
    @State private var showPopover: Bool = false
    init() {
        print(showPopover)
    }
    var body: some View {
        NavigationView {
            RoomsView()
            .navigationBarTitle(Text("your rooms"))
            .navigationBarItems(trailing: Button(action: {
                self.showPopover = true
            }, label: {
                Text("new").font(.custom("SF Pro Display", size: 24))
            })
            .padding()
            .foregroundColor(Colors.active))
            // TODO: fix popover, doesn't work when pressed a second time
            .popover(isPresented: self.$showPopover, arrowEdge: .bottom) {
                NewRoomView(showPopover: self.$showPopover)
            }
        }
    
    }
}

struct LoginView: View {
    var body: some View {
        VStack() {
            Text("Hello Kishan")
            Text("Subtitle")
                    .font(.subheadline)
            LoginButton()
                .frame(width: 180, height: 30, alignment: .center)
            Button(action: { print("clicked") }, label: { Text("Click to view lobby") })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
