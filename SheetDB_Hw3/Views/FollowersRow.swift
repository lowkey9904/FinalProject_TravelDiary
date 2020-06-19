//
//  FollowersRow.swift
//  SheetDB_Hw3
//
//  Created by Joker on 2020/6/10.
//  Copyright © 2020 ntoucs. All rights reserved.
//

import SwiftUI
import URLImage

struct FollowersRow: View {
    @State var followerID:String
    @State var followerName = ""
    @State var followerImg = ""
    @State private var AllFollower = [String]()
    var body: some View {
        HStack{
            if self.followerImg != ""{
                URLImage(URL(string: self.followerImg)!){
                    proxy in
                    proxy.image
                    .resizable()
                    .scaledToFill()
                    .frame(width:70, height: 70)
                    .cornerRadius(.infinity)
                    .shadow(radius: 5)
                }.padding(.trailing)
            }
            Text(self.followerName)
            Spacer()
            if(userDefaults.string(forKey: "userLoginAPPID")! != self.followerID && self.AllFollower.firstIndex(of: userDefaults.string(forKey: "userLoginAPPID")!) == nil){
                Button(action:{
                    self.AllFollower.append(userDefaults.string(forKey: "userLoginAPPID")!)
                    ApiControl.shared.ModifyFollowAPI(followID: self.followerID, followArray: self.AllFollower){
                        (result) in
                        switch result{
                        case .success(_):
                            print("Modify follow status success.")
                        case .failure(_):
                            print("Modify follow status fail.")
                        }
                    }
                }){
                    Text("Follow")
                        .padding(.horizontal, 20)
                        .padding(.vertical, 5)
                        .foregroundColor(.white)
                        .background(Color.black)
                        .cornerRadius(10)
                }
            }else if(userDefaults.string(forKey: "userLoginAPPID")! != self.followerID && self.AllFollower.firstIndex(of: userDefaults.string(forKey: "userLoginAPPID")!) != nil){
                Button(action:{
                    let removeIndex = self.AllFollower.firstIndex(of: userDefaults.string(forKey: "userLoginAPPID")!)
                    self.AllFollower.remove(at: removeIndex!)
                    ApiControl.shared.ModifyFollowAPI(followID: self.followerID, followArray: self.AllFollower){
                        (result) in
                        switch result{
                        case .success(_):
                            print("Modify follow status success.")
                        case .failure(_):
                            print("Modify follow status fail.")
                        }
                    }
                }){
                    Text("Followed")
                        .padding(.horizontal, 15)
                        .padding(.vertical, 5)
                        .foregroundColor(.white)
                        .background(Color.gray)
                        .cornerRadius(10)
                }
            }
        }.padding(.horizontal)
        .onAppear{
            ApiControl.shared.GetProfileAPI(UserID: self.followerID){
                (result) in
                switch result{
                case .success(let FollowerProfile):
                    self.followerImg = FollowerProfile.profile.profileUrl
                    self.followerName = FollowerProfile.profile.firstName + " " + FollowerProfile.profile.lastName
    //                    print(self.followerName)
    //                    print(self.followerImg)
                case .failure(_):
                    print("Get follower fail.")
                }
            }
            ApiControl.shared.GetFollowAPI(UserID: self.followerID){
                (result) in
                switch result{
                case .success(let FollowerDec):
                    self.AllFollower = FollowerDec.profile.followers
                case .failure( _):
                    print("Error")
                }
            }
        }
    }
}

struct FollowersRow_Previews: PreviewProvider {
    static var previews: some View {
        FollowersRow(followerID: "00u5il1midEajcFEE4x6")
    }
}
