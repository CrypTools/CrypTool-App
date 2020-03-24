//
//  ContentView.swift
//  CrypTool
//
//  Created by Arthur Guiot on 2020-03-23.
//  Copyright © 2020 Arthur Guiot. All rights reserved.
//

import SwiftUI
import QGrid

struct ContentView: View {
    @State private var selection = 0
    @State var cells: [Level]?
    var body: some View {
        TabView(selection: $selection) {
            QGrid(cells ?? [], columns: 1) { LevelCell(level: $0, index: 0) }
            .tabItem {
                    VStack {
                        Image("first")
                        Text("First")
                    }
            }
                .tag(0)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(cells: [Level(id: "caesar", name: "CaesarCipher", questionURL: "", answer: "")])
    }
}
