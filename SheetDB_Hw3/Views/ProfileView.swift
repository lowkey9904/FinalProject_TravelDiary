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
    @State var userGetProfileMain:UGProfileDec
    @State var AllUserPostListMain:[MyData]
    @State private var AllFollowerMain = [String]()
    @Environment(\.presentationMode) var presentationModeMain: Binding<PresentationMode>
    var body: some View{
        GeometryReader{
            geometry in
            LinearGradient(gradient: Gradient(colors: [Color(red: 245/255, green: 230/255, blue: 170/255), Color.white]), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1))
            .edgesIgnoringSafeArea(.vertical)
                .overlay(
            CustomScrollView(userGetProfile: self.userGetProfileMain, AllUserPostList: self.AllUserPostListMain, width: geometry.size.width, height: geometry.size.height).navigationBarTitle("Profile"))
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ProfileView(userGetProfileMain: UGProfileDec(id: "00u97gz2xh3GgXDIm4x6", status: "XXX", created: "XXX", profile: Profile(firstName: "Love", lastName: "Brook", email: "kk123@g.com", login: "XXX", birthday: "19990309", profileUrl: "https://i.imgur.com/rlBzghZ.jpeg")), AllUserPostListMain: [])
        }
    }
}

struct ProfileSubView: View{
    
    @Binding var userGetProfile:UGProfileDec
    @Binding var AllUserPostList:[MyData]
    @State private var AllFollower = [String]()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color(red: 245/255, green: 230/255, blue: 170/255), Color.white]), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1))
        .edgesIgnoringSafeArea(.vertical)
            .overlay(
        VStack(alignment: .leading){
            HStack{
                if self.userGetProfile.profile.profileUrl != ""{
                    URLImage(URL(string: self.userGetProfile.profile.profileUrl)!){ proxy in
                        proxy.image
                            .resizable()
                            .scaledToFill()
                            .frame(width:UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/3)
                            //.cornerRadius(10)
                            .clipped()
                            .shadow(radius: 5)
                    }
                }
                else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFill()
                        .frame(width:UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/3)
                        .clipped()
                        .foregroundColor(.gray)
                }
            }
            HStack{
                //自己不能follow自己
                if(userDefaults.string(forKey: "userLoginAPPID")! != self.userGetProfile.id && self.AllFollower.firstIndex(of: userDefaults.string(forKey: "userLoginAPPID")!) == nil){
                    Button(action:{
                        self.AllFollower.append(userDefaults.string(forKey: "userLoginAPPID")!)
                        ApiControl.shared.ModifyFollowAPI(followID: self.userGetProfile.id, followArray: self.AllFollower){
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
                            .padding(.horizontal, 44)
                            .padding(.vertical, 5)
                            .foregroundColor(.white)
                            .background(Color.black)
                            .cornerRadius(10)
                    }
                }else if(userDefaults.string(forKey: "userLoginAPPID")! != self.userGetProfile.id && self.AllFollower.firstIndex(of: userDefaults.string(forKey: "userLoginAPPID")!) != nil){
                    Button(action:{
                        let removeIndex = self.AllFollower.firstIndex(of: userDefaults.string(forKey: "userLoginAPPID")!)
                        self.AllFollower.remove(at: removeIndex!)
                        ApiControl.shared.ModifyFollowAPI(followID: self.userGetProfile.id, followArray: self.AllFollower){
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
                            .padding(.horizontal, 35)
                            .padding(.vertical, 5)
                            .foregroundColor(.white)
                            .background(Color.gray)
                            .cornerRadius(10)
                    }
                }
                NavigationLink(destination: FollowersView(AllFollower: self.$AllFollower)){
                    Text("Followers: " + String(self.AllFollower.count))
                        .padding(.horizontal, 25)
                        .padding(.vertical, 5)
                        .foregroundColor(.white)
                        .background(Color.black)
                        .cornerRadius(10)
                    //.offset(x: 10)
                }
                if (userDefaults.string(forKey: "userLoginAPPID")! == self.userGetProfile.id){
                    NavigationLink(destination: NewPostView(userID: userDefaults.string(forKey: "userLoginAPPID")!, userFN: self.userGetProfile.profile.firstName, userLN: self.userGetProfile.profile.lastName)){
                        Text("New Post")
                            .padding(.horizontal, 35)
                            .padding(.vertical, 5)
                            .foregroundColor(.white)
                            .background(Color.black)
                            .cornerRadius(10)
                        //.offset(x: 10)
                    }
                    Spacer()
                    NavigationLink(destination: ModifyProfileView(userID: userDefaults.string(forKey: "userLoginAPPID")!)){
                        Image(systemName: "slider.horizontal.3")
                            .resizable()
                            .renderingMode(.original)
                            .foregroundColor(.black)
                            .frame(width: 30, height: 25)
                    }
                }
            }.padding(.horizontal)
            if (userDefaults.string(forKey: "userLoginAPPID")! == self.userGetProfile.id){
                NavigationLink(destination: DiaryView()){
                    Text("YourDiary")
                        .padding(.horizontal, 33)
                        .padding(.vertical, 5)
                        .foregroundColor(.white)
                        .background(Color.black)
                        .cornerRadius(10)
                }.padding(.horizontal)
            }
            List{
                VStack(alignment: .leading){
                    Text(userGetProfile.profile.firstName + " " + userGetProfile.profile.lastName).bold()
                        .padding(.bottom, 10)
                        .font(.custom("Times", size: 30))
                    Text(userGetProfile.profile.email)
                    Text(userGetProfile.profile.birthday)
                }.font(.custom("Times", size: 18))
                
                Text("Post")
                    .font(.custom("Times", size: 22))
                ForEach(0..<self.AllUserPostList.count, id: \.self){ (index) in
                    ProfileListRow(Post: self.AllUserPostList[self.AllUserPostList.count - index - 1])
                        .listRowInsets(EdgeInsets())
                }
            }
        }
            .onAppear{
                //登入帳號
                print(userDefaults.string(forKey: "userLoginAPPID")!)
                //此頁面帳號
                print(self.userGetProfile.id)
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
                ApiControl.shared.GetFollowAPI(UserID: self.userGetProfile.id){
                    (result) in
                    switch result {
                    case .success(let AllFollow):
                        self.AllFollower = AllFollow.profile.followers
                    case .failure( _):
                        print("Cannot find followers.")
                    }
                }
        })
    }
}

struct CustomScrollView : UIViewRepresentable {
    
    @State var userGetProfile:UGProfileDec
    @State var AllUserPostList:[MyData]
    var width : CGFloat
    var height : CGFloat
        
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    func makeUIView(context: Context) -> UIScrollView {
        let control = UIScrollView()
        control.refreshControl = UIRefreshControl()
        control.refreshControl?.addTarget(context.coordinator, action:
            #selector(Coordinator.handleRefreshControl), for: .valueChanged)
        let childView = UIHostingController(rootView: ProfileSubView(userGetProfile: $userGetProfile, AllUserPostList: $AllUserPostList))
        childView.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        control.addSubview(childView.view)
        return control
    }
    func updateUIView(_ uiView: UIScrollView, context: Context)  {
        //print("Update View")
    }
    class Coordinator: NSObject {
        var control: CustomScrollView
        init(_ control: CustomScrollView) {
            self.control = control
        }
        @objc func handleRefreshControl(sender: UIRefreshControl) {
            sender.endRefreshing()
            ApiControl.shared.GetProfileAPI(UserID: self.control.userGetProfile.id){
                (result) in
                switch result{
                case .success(let userProfile):
                    self.control.userGetProfile = userProfile
                case .failure( _):
                    print("Update Error.")
                }
            }
            ApiControl.shared.GetAllPostAPI{
                (result) in
                switch result {
                case .success(let AllPost):
                    var count = 0
                    for i in 0...AllPost.count - 1{
                        if AllPost[i].userID == self.control.userGetProfile.id {
                            count += 1
                        }
                    }
                    if self.control.AllUserPostList.count != count{
                        self.control.AllUserPostList.removeAll()
                        for i in 0...AllPost.count - 1{
                            if AllPost[i].userID == self.control.userGetProfile.id {
                                self.control.AllUserPostList.append(AllPost[i])
                            }
                        }
                    }
                case .failure( _):
                    print("Error")
                }
            }
            
            print("Refreshing")
        }
    }
}
