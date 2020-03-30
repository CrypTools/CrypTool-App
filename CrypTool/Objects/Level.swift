//
//  Level.swift
//  CrypTool
//
//  Created by Arthur Guiot on 2020-03-23.
//  Copyright © 2020 Arthur Guiot. All rights reserved.
//

import Foundation

class Level: Identifiable {
    var id: String;
    var name: String;
    var questionURL: String;
    var answer: String;
    var content: String {
        guard let url = URL(string: self.questionURL) else { return "" }
        return (try? String(contentsOf: url)) ?? ""
    }
    
    var index: Int
    
    static var empty: Level {
        return Level(id: "0", name: "0", questionURL: "0", answer: "0")
    }
    
    init(id: String, name: String, questionURL: String, answer: String, index: Int = 0) {
        self.id = id
        self.name = name
        self.questionURL = "https://cryptools.github.io/learn/noob_questions/\(questionURL)"
        self.answer = answer
        self.index = index
    }
}
