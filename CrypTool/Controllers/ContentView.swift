//
//  ContentView.swift
//  CrypTool
//
//  Created by Arthur Guiot on 2020-03-23.
//  Copyright © 2020 Arthur Guiot. All rights reserved.
//

import SwiftUI
import QGrid
import Alamofire
import SwiftyJSON

struct ContentView: View {
    @State private var selection = 0
    @State var cells: [Level]?
    @State var loading = true
    
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

        return false
    }
    
    var body: some View {
        TabView(selection: $selection) {
            NavigationView {
                LoadingView(isShowing: $loading) {
                    QGrid(self.cells ?? [], columns: Int(UIScreen.main.bounds.width / (300 + 100)), vPadding: 0) { l in
                        NavigationLink(destination: LevelView(level: l)) {
                            LevelCell(level: l)
                        }
                    }
                    .navigationBarItems(leading: Image("LogoHD")
                        .resizable()
                        .frame(width: 64, height: 64)
                    )
                    .navigationBarTitle(
                        Text("Learn")
                            .foregroundColor(Color.black)
                    )
                    .onAppear {
                        self.getLevels()
                    }
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                    VStack {
                        Image("learnTab")
                        Text("Learn")
                        .font(.system(size: 18, weight: .bold, design: .monospaced))
                    }
            }.tag(0)
            EncryptView().tabItem {
                VStack {
                    Image(systemName: "lock.rotation")
                        .font(.system(size: 18.0, weight: .bold))
                        .imageScale(.large)
                    Text("Encrypt")
                    .font(.system(size: 18, weight: .bold, design: .monospaced))
                }
            }.tag(1)
        }.edgesIgnoringSafeArea(hasTopNotch ? [.top] : []).accentColor(Color(#colorLiteral(red: 0.2980392157, green: 0.6862745098, blue: 0.3137254902, alpha: 1)))
    }
    
    func getLevels() {
        let location = "https://cryptools.github.io/learn/api/challenges.json"
        
        AF.request(location).responseJSON {
            response in
            if (response.error != nil) {
                print(response.error?.localizedDescription)
                return
            }
            do {
                let json = try JSON(data: response.data!)
                let noob = json["challenges"]["noob"]
                
                self.cells = []
                var indx = 0
                for i in noob.arrayValue {
                    let level = Level(id: i["name"].string!, name: i["fancy"].string!, questionURL: i["question"].string!, answer: i["answer"].stringValue, index: indx)
                    self.cells?.append(level)
                    indx += 1
                }
                
                self.loading = false
                
                let appGroupID = "group.com.ArthurG.CrypTools"
                let defaults = UserDefaults(suiteName: appGroupID)
                defaults?.setValue(self.cells?.count ?? 1, forKey: "levels")
                
                self.defaults()
            } catch {
                print("JSON Parsing Error")
            }
        }
    }
    func defaults() {
        let appGroupID = "group.com.ArthurG.CrypTools"
        let defaults = UserDefaults(suiteName: appGroupID)
        if (defaults?.array(forKey: "done") == nil) {
            defaults?.set([], forKey: "done")
            defaults?.set(1, forKey: "levels")
        }
        defaults?.synchronize()
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
