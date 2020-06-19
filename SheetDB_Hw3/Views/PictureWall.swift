//
//  PictureWall.swift
//  SheetDB_Hw3
//
//  Created by Joker on 2020/5/9.
//  Copyright © 2020 ntoucs. All rights reserved.
//

import SwiftUI
import URLImage
import Foundation

struct PictureWall: View {
    
    @State var AllPostList:[MyData]
    @State var AllUserData:[UGProfileDec]
    @State var userGetProfile:UGProfileDec
    @State var ProfileURL = [String]()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color(red: 245/255, green: 230/255, blue: 170/255), Color.white]), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1))
        .edgesIgnoringSafeArea(.vertical)
            .overlay(
        VStack{
            List{
                ScrollView(.horizontal){
                    HStack(spacing: 20){
                        ForEach(0..<AllUserData.count, id: \.self){ (index) in
                            VStack{
                                NavigationLink(destination: ProfileView(userGetProfileMain: self.AllUserData[index], AllUserPostListMain: [])){
                                    URLImage(URL(string: self.AllUserData[index].profile.profileUrl)!){
                                        (proxy) in
                                        proxy.image
                                            .renderingMode(.original)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 75, height: 75)
                                            .clipped()
                                            .cornerRadius(.infinity)
                                            .shadow(radius: 5)
                                    }
                                }
                                Text(self.AllUserData[index].profile.firstName + " " + self.AllUserData[index].profile.lastName)
                                    .font(.custom("Times", size: 18))
                            }
                        }
                    } .frame(height: 135)
                }
                ForEach(0..<AllPostList.count, id: \.self){ (index) in
                    NavigationLink(destination: PostRow(Post: self.AllPostList[self.AllPostList.count - index - 1])){
                        PostRow(Post: self.AllPostList[self.AllPostList.count - index - 1])
                        
                    }.listRowInsets(EdgeInsets())
                        .offset(x:7)
                        .padding(.bottom, 30)
                }
            }
        }
        .navigationBarTitle("News Feed", displayMode: .inline)
            .navigationBarItems(leading:
                HStack{
                    NavigationLink(destination: ProfileView(userGetProfileMain: self.userGetProfile, AllUserPostListMain: [])){
                        HStack{
                            Image(systemName: "person.circle")
                                .renderingMode(.original)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20)
                            Text("Profile")
                                .font(.custom("Times", size: 20))
                        }.foregroundColor(.black)
                    }
                }, trailing: Button(action:{
                    userDefaults.set("unknown", forKey: "userLoginAPPID")
                    self.presentationMode.wrappedValue.dismiss()
                }){
                    HStack{
                        Image(systemName: "arrowshape.turn.up.left.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                        Text("Logout")
                            .font(.custom("Times", size: 20))
                        
                    }.foregroundColor(.black)
            })
            .navigationBarBackButtonHidden(true)
            .onAppear{
//                ApiControl.shared.GetAllPostAPI{
//                    (result) in
//                    switch result {
//                    case .success(let AllPost):
//                        self.AllPostList = AllPost
//                    case .failure( _):
//                        print("Error")
//                    }
//                }
                ApiControl.shared.GetAllUserAPI(){
                    (result) in
                    switch result {
                    case .success(let AllUser):
                        self.AllUserData = AllUser
                    case .failure( _):
                        print("User Error")
                    }
                }
        })
    }
}

struct PictureWall_Previews: PreviewProvider {
    static var previews: some View {
        PictureWall(AllPostList: [], AllUserData: [], userGetProfile: UGProfileDec(id: "XXX", status: "XXX", created: "XXX", profile: Profile(firstName: "XXX", lastName: "XXX", email: "XXX", login: "XXX", birthday: "19990309", profileUrl: "https://i.imgur.com/rlBzghZ.jpeg")))
    }
}
