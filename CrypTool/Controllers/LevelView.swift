//
//  LevelView.swift
//  CrypTool
//
//  Created by Arthur Guiot on 2020-03-24.
//  Copyright © 2020 Arthur Guiot. All rights reserved.
//

import SwiftUI

struct LevelView: View {
    @State var answer: String = ""
    @State private var isOpen = false
    @State var level: Level
    var body: some View {
        ZStack {
            SWDownView(text: level.content)
            BottomSheetView(isOpen: $isOpen, maxHeight: 300.0) {
                HStack {
                    Text("Answer")
                    TextField("Answer", text: $answer)
                }
            }
        }
    }
}

struct LevelView_Previews: PreviewProvider {
    static var previews: some View {
        LevelView(level: Level(id: "caesar", name: "Caesar Cipher", questionURL: "emojigraphy.md", answer: ""))
    }
}
