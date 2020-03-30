//
//  LearnView.swift
//  CrypTool
//
//  Created by Arthur Guiot on 2020-03-29.
//  Copyright © 2020 Arthur Guiot. All rights reserved.
//

import SwiftUI
import QGrid
import Alamofire
import SwiftyJSON

struct LearnView: View {
    @State var cells: [Level] = [Level.empty]
    @State var loading = true
    
    let appGroupID = "group.com.ArthurG.CrypTools"
    var userDefaults: UserDefaults? {
        return UserDefaults(suiteName: appGroupID)
    }
    var done: [String]? {
        return userDefaults?.array(forKey: "done") as? [String]
    }
    
    var body: some View {
        LoadingView(isShowing: $loading) {
            GeometryReader { geometry in
                #if targetEnvironment(macCatalyst)
                List(self.cells) { l in
                    NavigationLink(destination: LevelView(level: l)) {
                        HStack {
                            Text(l.name)
                            Spacer()
                            if self.done?.contains(where: { $0 == l.id }) ?? false {
                                Circle()
                                .frame(width: 18, height: 18)
                                .foregroundColor(Color(#colorLiteral(red: 0.2980392157, green: 0.6862745098, blue: 0.3137254902, alpha: 1)))
                            }
                        }
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
                #else
                QGrid(self.cells, columns: Int(geometry.size.width / (300 + 100)), vPadding: 0) { l in
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
                #endif
            }
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
                    self.cells.append(level)
                    indx += 1
                }
                
                self.loading = false
                
                let appGroupID = "group.com.ArthurG.CrypTools"
                let defaults = UserDefaults(suiteName: appGroupID)
                defaults?.setValue(self.cells.count, forKey: "levels")
                
                self.defaults()
            } catch {
                print("JSON Parsing Error")
            }
        }
    }
    func defaults() {
        if (userDefaults?.array(forKey: "done") == nil) {
            userDefaults?.set([], forKey: "done")
            userDefaults?.set(1, forKey: "levels")
        }
        userDefaults?.synchronize()
        
    }
}

struct LearnView_Previews: PreviewProvider {
    static var previews: some View {
        LearnView()
    }
}
