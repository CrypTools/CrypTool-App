//
//  LevelView.swift
//  CrypTool
//
//  Created by Arthur Guiot on 2020-03-24.
//  Copyright © 2020 Arthur Guiot. All rights reserved.
//

import SwiftUI
import AudioToolbox

struct LevelView: View {
    @State var answer: String = ""
    @State private var isOpen = false
    @State var level: Level
    @State var showCongrats = false
    
    @State var message = "Confirm your answer!"
    @State var msgColor = Color.black
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var content: String?
    @State var loading = true
    var body: some View {
        ZStack(alignment: .top) {
            LoadingView(isShowing: $loading) {
                SWDownView(text: self.content ?? "")
            }.onAppear {
                DispatchQueue.global().async {
                    self.content = self.level.content
                    self.loading = false
                }
            }
            BottomSheetView(isOpen: $isOpen, maxHeight: UIScreen.main.bounds.height / 1.5, minHeight: 250) {
                VStack {
                    HStack(alignment: .center) {
                        Text("Answer")
                            .font(.system(size: 18, weight: .bold, design: .monospaced))
                        TextField("Result", text: $answer, onEditingChanged: { _ in
                            self.valueChanged()
                        }).textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 150)
                            .onTapGesture {
                                self.isOpen = true
                            }
                        Button(action: {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            self.valueChanged()
                        }) {
                            Image("forward")
                        }
                    }
                    Text(self.message)
                        .font(.system(size: 18, weight: .medium, design: .monospaced))
                        .foregroundColor(self.msgColor)
                }
            }
            VStack {
                 Text("Congratulations 🎉! Your answer is correct ✅")
                .foregroundColor(Color(#colorLiteral(red: 0, green: 0.5019607843, blue: 0, alpha: 1)))
                    .font(.system(size: 24, weight: .bold, design: .monospaced))
                    .multilineTextAlignment(.center)
                Button(action: {
                    let appGroupID = "group.com.ArthurG.CrypTools"
                    let defaults = UserDefaults(suiteName: appGroupID)
                    var doneArray = defaults?.array(forKey: "done")
                    doneArray?.append(self.level.id)
                    defaults?.setValue(doneArray, forKey: "done")
                    
                    defaults?.synchronize()
                    
                self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image("back")
                        .foregroundColor(Color.black)
                }
            }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .background(Color.white)
            .offset(x: 0, y: showCongrats ? 0 : UIScreen.main.bounds.height)
                .animation(.easeInOut)
        }
    }
    
    func valueChanged() {
        if answer.lowercased() == level.answer.lowercased() {
            self.showCongrats = true
            
            let filename = "success"
            let ext = "m4a"
            
            if #available(iOS 10.0, *) {
                let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
                notificationFeedbackGenerator.prepare()
                notificationFeedbackGenerator.notificationOccurred(.success)
            }
            if let soundUrl = Bundle.main.url(forResource: filename, withExtension: ext) {
                var soundId: SystemSoundID = 0
                
                AudioServicesCreateSystemSoundID(soundUrl as CFURL, &soundId)
                
                AudioServicesAddSystemSoundCompletion(soundId, nil, nil, { (soundId, clientData) -> Void in
                    AudioServicesDisposeSystemSoundID(soundId)
                }, nil)
                
                AudioServicesPlaySystemSound(soundId)
                
            }
        } else if answer != "" {
            self.msgColor = Color.red
            self.message = "Oupps 🤭! Try again. ❎"
        }
    }
}

struct LevelView_Previews: PreviewProvider {
    static var previews: some View {
        LevelView(level: Level(id: "caesar", name: "Caesar Cipher", questionURL: "emojigraphy.md", answer: "Test"))
    }
}
