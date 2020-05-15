//
//  ProfileView.swift
//  SheetDB_Hw3
//
//  Created by Joker on 2020/5/9.
//  Copyright © 2020 ntoucs. All rights reserved.
//

import SwiftUI
import URLImage

struct ProfileView: View {
    
    @State var userGetProfile:UGProfileDec
    @State var AllUserPostList:[MyData]
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                if self.userGetProfile.profile.profileUrl != ""{
                    URLImage(URL(string: self.userGetProfile.profile.profileUrl)!){ proxy in
                        proxy.image
                            .resizable()
                            .scaledToFill()
                            .frame(width:150, height: 150)
                            .cornerRadius(.infinity)
                            .shadow(radius: 30)
                    }
                    .padding(.bottom, 70)
                }
                else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFill()
                        .frame(width:150, height: 150)
                        .cornerRadius(.infinity)
                        .shadow(radius: 30)
                        .foregroundColor(.gray)
                }
                
                VStack(alignment: .leading){
                    Text(userGetProfile.profile.firstName + " " + userGetProfile.profile.lastName).bold()
                        .padding(.bottom, 10)
                        .font(.custom("Times", size: 30))
                    HStack{
                        Image(systemName: "envelope")
                        Text(userGetProfile.profile.email)
                    }
                    HStack{
                        Image(systemName: "calendar")
                        Text(userGetProfile.profile.birthday)
                    }
                    .padding(.bottom, 10)
                    
                }.offset(x:30, y:-40)
                    .font(.custom("Times", size: 22))
            }.padding(.horizontal)
            Text("Your Post")
            .font(.custom("Times", size: 22))
            List(){
                ForEach(0..<self.AllUserPostList.count, id: \.self){ (index) in
                    ProfileListRow(Post: self.AllUserPostList[index])
                        .listRowInsets(EdgeInsets())
                    }
            }
        }.padding()
            //.offset(y:-20)
            .onAppear{
                ApiControl.shared.GetAllPostAPI{
                    (result) in
                    switch result {
                    case .success(let AllPost):
                        var count = 0
                        for i in 0...AllPost.count - 1{
                            if AllPost[i].userID == self.userGetProfile.id {
                                count += 1
                            }
                        }
                        if self.AllUserPostList.count != count{
                            self.AllUserPostList.removeAll()
                            for i in 0...AllPost.count - 1{
                                if AllPost[i].userID == self.userGetProfile.id {
                                    self.AllUserPostList.append(AllPost[i])
                                }
                            }
                        }
                    case .failure( _):
                        print("Error")
                    }
                }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ProfileView(userGetProfile: UGProfileDec(id: "00u97gz2xh3GgXDIm4x6", status: "XXX", created: "XXX", lastLogin: "XXX", profile: ProfileUG(firstName: "Love", lastName: "Brook", email: "kk123@g.com", login: "XXX", birthday: "19990309", profileUrl: "https://i.imgur.com/rlBzghZ.jpeg")), AllUserPostList: [])
        }
    }
}
