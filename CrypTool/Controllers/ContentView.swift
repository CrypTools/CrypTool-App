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
    
    var body: some View {
        TabView(selection: $selection) {
            NavigationView {
                LoadingView(isShowing: $loading) {
                    QGrid(self.cells ?? [], columns: 1, vPadding: 0) { l in
                        NavigationLink(destination: LevelView(level: l)) {
                            LevelCell(level: l)
                        }
                    }
                    .navigationBarTitle(Text("CrypTool")
                    .foregroundColor(Color.black))
                    .onAppear {
                        self.getLevels()
                    }
                }
            }
            .tabItem {
                    VStack {
                        Image("learnTab")
                        Text("Learn")
                    }
            }.tag(0)
        }
        
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
