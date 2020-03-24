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
    init(id: String, name: String, questionURL: String, answer: String) {
        self.id = id
        self.name = name
        self.questionURL = "https://cryptools.github.io/learn/noob_questions/\(questionURL)"
        self.answer = answer
    }
}
