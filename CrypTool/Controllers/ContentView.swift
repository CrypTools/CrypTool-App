//
//  ContentView.swift
//  CrypTool
//
//  Created by Arthur Guiot on 2020-03-23.
//  Copyright © 2020 Arthur Guiot. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .font : UIFont.monospacedSystemFont(ofSize: 36, weight: .bold)]
                
        // 3.
        UINavigationBar.appearance().titleTextAttributes = [
            .font : UIFont.monospacedSystemFont(ofSize: 20, weight: .bold)]
          }
    
    var hasTopNotch: Bool {
        #if targetEnvironment(macCatalyst)
            return false
        #endif
        if #available(iOS 13.0,  *) {
            return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0 > 20
        }else{
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
    }
    
    var isMac: Bool {
        #if targetEnvironment(macCatalyst)
            return true
        #endif
        return false
    }
    
    var body: some View {
        TabView(selection: $selection) {
            #if targetEnvironment(macCatalyst)
                NavigationView {
                    LearnView()
                }
                .navigationViewStyle(DefaultNavigationViewStyle())
                .tabItem {
                        VStack {
                            Image("learnTab")
                            Text("Learn")
                            .font(.system(size: 18, weight: .bold, design: .monospaced))
                        }
                }.tag(0)
            #else
            NavigationView {
                LearnView()
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                    VStack {
                        Image("learnTab")
                        Text("Learn")
                        .font(.system(size: 18, weight: .bold, design: .monospaced))
                    }
            }.tag(0)
            #endif
            EncryptView().tabItem {
                VStack {
                    Image(systemName: "lock.rotation")
                        .font(.system(size: 18.0, weight: .bold))
                        .imageScale(.large)
                    Text("Encrypt")
                    .font(.system(size: 18, weight: .bold, design: .monospaced))
                }
            }.tag(1)
        }
//        .edgesIgnoringSafeArea(hasTopNotch ? [.top] : [])
        .accentColor(Color(#colorLiteral(red: 0.07058823529, green: 0.4666666667, blue: 0.9215686275, alpha: 1)))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
