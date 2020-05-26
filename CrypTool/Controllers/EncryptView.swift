//
//  EncryptView.swift
//  CrypTool
//
//  Created by Arthur Guiot on 2020-03-25.
//  Copyright © 2020 Arthur Guiot. All rights reserved.
//

import SwiftUI
import MessageUI

struct EncryptView: View {
    @State private var isOpen = false
    @State private var message = ""
    
    @State private var ciphers = Cipher()
    @State private var selection = 0
    @State private var key = ""
    
    @State private var encrypted = ""
    
    @State var result: Result<MessageComposeResult, Error>? = nil
    @State var isShowingMessageView = false
    
    var shareableString: String {
        """
        ---------- \(self.ciphers.name[self.selection]) ----------
        \(self.ciphers.get(self.ciphers.name[self.selection])(self.message, self.key))
        ---------- \(key) ----------
        """
    }
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Image("LogoHD")
                        .resizable()
                        .frame(width: 64, height: 64)
                        Text("Ciphers")
                        .font(.system(size: 36, weight: .bold, design: .monospaced))
                        .multilineTextAlignment(.leading)
                        Spacer()
                        #if !targetEnvironment(macCatalyst)
                        Button(action: {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            self.isOpen = true
                        }) {
                            Text("Show Result")
                        }
                        #endif
                    }
                    MultilineTextField("Enter your text here", text: $message)
                    HStack {
                        Spacer()
                        Picker(selection: $selection, label: Text("Ciphers")) {
                            ForEach(0..<ciphers.name.count) {
                                Text(self.ciphers.name[$0])
                                .font(.system(size: 18, weight: .bold, design: .monospaced))
                            }
                        }.labelsHidden()
                        Spacer()
                    }
                    TextField("Enter your key", text: $key)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                }
                .padding(.horizontal)
                .padding(.bottom, UIScreen.main.bounds.height / 1.5)
            }
            BottomSheetView(isOpen: $isOpen, maxHeight: UIScreen.main.bounds.height / 1.5, minHeight: 250) {
                GeometryReader { geometry in
                    ScrollView {
                        VStack {
                            Text("Result")
                                .font(.system(size: 18, weight: .bold, design: .monospaced))
                                .padding()
                            Text(self.ciphers.get(self.ciphers.name[self.selection])(self.message, self.key))
                            .padding()
                                .frame(width: geometry.size.width - 40)
                            .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.black))
                            
                            HStack {
                                Button(action: {
                                    UIPasteboard.general.string = self.ciphers.get(self.ciphers.name[self.selection])(self.message, self.key)
                                }) {
                                    VStack {
                                        Image(systemName: "doc.on.doc")
                                        Text("Copy")
                                    }
                                }
                                .padding()
                                
                                Button(action: {
                                    self.isShowingMessageView.toggle()
                                }) {
                                    VStack {
                                        Image(systemName: "message")
                                        Text("Message")
                                    }
                                }
                                .padding()
                                .disabled(!MFMessageComposeViewController.canSendText())
                                .sheet(isPresented: self.$isShowingMessageView) {
                                    MessageView(result: self.$result, content: self.shareableString)
                                }
                            }.padding()
                        }
                    }
                }
            }
        }
    }
}

struct EncryptView_Previews: PreviewProvider {
    static var previews: some View {
        EncryptView()
    }
}
