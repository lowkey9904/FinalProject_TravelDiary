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
    @State var userGetProfile:UGProfileDec
    @State var ProfileURL = [String]()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack{
            HStack{
                NavigationLink(destination: ProfileView(userGetProfile: self.userGetProfile, AllUserPostList: [])){
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
                Spacer()
                NavigationLink(destination: NewPostView(userID: self.userGetProfile.id, userFN: self.userGetProfile.profile.firstName, userLN: self.userGetProfile.profile.lastName)){
                    HStack{
                        Image(systemName: "pencil.circle")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                        Text("New Post")
                            .font(.custom("Times", size: 20))
                        
                    }.foregroundColor(.black)
                }
                Spacer()
                Button(action:{
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
                }
            }.padding()
            List{
                ForEach(0..<AllPostList.count, id: \.self){ (index) in
                    NavigationLink(destination: PostRow(Post: self.AllPostList[self.AllPostList.count - index - 1])){
                    PostRow(Post: self.AllPostList[self.AllPostList.count - index - 1])
                        
                    }.listRowInsets(EdgeInsets())
                    .offset(x:7)
                    .padding(.bottom, 30)
                }
            }
        }.navigationBarBackButtonHidden(true)
            .navigationBarTitle(Text("News Feed"), displayMode: .inline)
            .onAppear{
                ApiControl.shared.GetAllPostAPI{
                    (result) in
                    switch result {
                    case .success(let AllPost):
                        self.AllPostList = AllPost
                    case .failure( _):
                        print("Error")
                    }
                }
        }
    }
}

struct PictureWall_Previews: PreviewProvider {
    static var previews: some View {
        PictureWall(AllPostList: [], userGetProfile: UGProfileDec(id: "XXX", status: "XXX", created: "XXX", lastLogin: "XXX", profile: ProfileUG(firstName: "XXX", lastName: "XXX", email: "XXX", login: "XXX", birthday: "19990309", profileUrl: "https://i.imgur.com/rlBzghZ.jpeg")))
    }
}
