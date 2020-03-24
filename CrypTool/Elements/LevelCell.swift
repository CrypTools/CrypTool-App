//
//  LevelCell.swift
//  CrypTool
//
//  Created by Arthur Guiot on 2020-03-23.
//  Copyright © 2020 Arthur Guiot. All rights reserved.
//

import SwiftUI

struct LevelCell: View {
    var level: Level
    var index: Int
    var body: some View {
        VStack {
            Text("#\(self.index + 1)")
                .font(.system(size: 32, weight: .bold, design: .monospaced))
                .frame(width: 300, height: 105)
                .background(Color.white)
            Text(level.name)
                .font(.system(size: 18, weight: .bold, design: .monospaced))
                .foregroundColor(Color.white)
                .frame(width: 300, height: 75)
                .background(Color.black)
        }
        .cornerRadius(15)
        .shadow(color: .gray, radius: 5, x: 0, y: 0)
        .frame(width: 300.0, height: 200)
    }
}

struct LevelCell_Previews: PreviewProvider {
    static var previews: some View {
        LevelCell(level: Level(id: "caesar", name: "Caesar Cipher", questionURL: "", answer: ""), index: 0)
    }
}
