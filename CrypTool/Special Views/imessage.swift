//
//  imessage.swift
//  CrypTool
//
//  Created by Arthur Guiot on 2020-05-25.
//  Copyright © 2020 Arthur Guiot. All rights reserved.
//

import SwiftUI
import MessageUI

struct MessageView: UIViewControllerRepresentable {

    @Environment(\.presentationMode) var presentation
    @Binding var result: Result<MessageComposeResult, Error>?
    var content: String
    
    class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            defer {
                $presentation.wrappedValue.dismiss()
            }
            self.result = .success(result)
        }
        

        @Binding var presentation: PresentationMode
        @Binding var result: Result<MessageComposeResult, Error>?

        init(presentation: Binding<PresentationMode>,
             result: Binding<Result<MessageComposeResult, Error>?>) {
            _presentation = presentation
            _result = result
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentation,
                           result: $result)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MessageView>) -> MFMessageComposeViewController {
        let vc = MFMessageComposeViewController()
        vc.messageComposeDelegate = context.coordinator
        vc.body = self.content
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMessageComposeViewController,
                                context: UIViewControllerRepresentableContext<MessageView>) {

    }
}
