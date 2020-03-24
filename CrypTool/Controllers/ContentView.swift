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
            NavigationView {
                QGrid(cells ?? [], columns: 1, vPadding: 0) { l in
                    NavigationLink(destination: LevelView(level: l)) {
                        LevelCell(level: l, index: 0)
                    }
                }
                .navigationBarTitle(Text("CrypTool")
                .foregroundColor(Color.black))
            }
            .tabItem {
                    VStack {
                        Image("learnTab")
                        Text("Learn")
                    }
            }.tag(0)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(cells: [Level(id: "caesar", name: "CaesarCipher", questionURL: "emojigraphy.md", answer: "")])
    }
}
