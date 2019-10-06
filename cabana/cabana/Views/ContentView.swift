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
    var totalClicked = 0
    var body: some View {
        VStack() {
            Text("Hello Kishan")
            Text("Subtitle")
                    .font(.subheadline)
            LoginButton()
                .frame(width: 180, height: 30, alignment: .center)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
