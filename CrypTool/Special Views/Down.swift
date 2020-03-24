//
//  Down.swift
//  CrypTool
//
//  Created by Arthur Guiot on 2020-03-24.
//  Copyright © 2020 Arthur Guiot. All rights reserved.
//

import UIKit
import Down

import WebKit
import SwiftUI

struct SWDownView: UIViewRepresentable {
    var text: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let d = Down(markdownString: text)
        let html = (try? d.toHTML()) ?? ""
        uiView.loadHTMLString(html, baseURL: nil)
    }
}
