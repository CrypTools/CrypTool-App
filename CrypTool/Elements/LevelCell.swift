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
    @State var finished = false
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Text("#\(self.level.index + 1)")
                    .font(.system(size: 32, weight: .bold, design: .monospaced))
                    .foregroundColor(Color.black)
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
            HStack {
                Spacer()
                
                if finished {
                    Circle()
                    .frame(width: 25, height: 25)
                    .foregroundColor(Color(#colorLiteral(red: 0.2980392157, green: 0.6862745098, blue: 0.3137254902, alpha: 1)))
                }
            }.frame(width: 325.0)
        }
    }
}

struct LevelCell_Previews: PreviewProvider {
    static var previews: some View {
        LevelCell(level: Level(id: "caesar", name: "Caesar Cipher", questionURL: "", answer: ""))
    }
}
