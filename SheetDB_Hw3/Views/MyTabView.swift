//
//  MyTabView.swift
//  SheetDB_Hw3
//
//  Created by Joker on 2020/6/19.
//  Copyright © 2020 ntoucs. All rights reserved.
//

import SwiftUI

struct MyTabView: View {
    //@State var tabViewProfile: UGProfileDec
    var body: some View {
        TabView{
            ContentView(userConGetProfile: UGProfileDec(id: "", status: "", created: "", profile: Profile(firstName: "", lastName: "", email: "", login: "", birthday: "", profileUrl: ""))).tabItem{
                Image(systemName:"house")
                Text("Travel Diary")
            }
            AttractionsView(myAttractions: Attractions(total: 0, data: [])).tabItem{
                Image(systemName: "lightbulb")
                Text("Taipei Discover Attractions")
            }
        }.accentColor(.black)
    }
}
