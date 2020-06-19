//
//  FollowersView.swift
//  SheetDB_Hw3
//
//  Created by Joker on 2020/6/10.
//  Copyright © 2020 ntoucs. All rights reserved.
//

import SwiftUI

struct FollowersView: View {
    @Binding var AllFollower:[String]
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color(red: 245/255, green: 230/255, blue: 170/255), Color.white]), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1))
        .edgesIgnoringSafeArea(.vertical)
            .overlay(
        VStack{
            if AllFollower.count != 0{
                List{
                    ForEach(0..<AllFollower.count, id: \.self){(index) in
                        FollowersRow(followerID: self.AllFollower[index])
                    }
                }.padding(.top, 10)
            }
            else{
                Image("Lonely")
                .resizable()
                .scaledToFill()
                .frame(width: 350, height: 200)
                .cornerRadius(30)
                .shadow(radius: 30)
                //.clipped()
                Text("No one is following him/her...")
            }
        }.navigationBarTitle("Followers List",displayMode: .inline))
    }
}

