//
//  ContentView.swift
//  SheetDB_Hw3
//
//  Created by Joker on 2020/5/7.
//  Copyright © 2020 ntoucs. All rights reserved.
//

import SwiftUI

let userDefaults = UserDefaults.standard

struct ContentView: View {
    
    @State private var un = ""
    @State private var pd = ""
    @State private var usertokenID = ""
    @State private var userID = ""
    @State private var showAlert = false
    @State private var showProfileView = false
    @State private var titleOpacity: Double = 0
    @State var userConGetProfile:UGProfileDec
    
    var body: some View {
        NavigationView{
            VStack{
                Text("Travel Diary")
                    .font(.custom("Zapfino", size: 35))
                    .foregroundColor(.black)
                    .opacity(self.titleOpacity)
                    //.animation(.easeOut)
                HStack{
                    Image(systemName: "person")
                        .foregroundColor(Color.white)
                    CustomTextField(placeholder: Text("Username").foregroundColor(Color(red:193/255, green:193/255, blue:193/255)),text:$un)
                        .foregroundColor(.white)
                }.padding()
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2))
                    .padding()
                HStack{
                    Image(systemName: "lock")
                        .foregroundColor(Color.white)
                    CustomSecureField(placeholder: Text("Password").foregroundColor(Color(red:193/255, green:193/255, blue:193/255)), text: $pd)
                        .foregroundColor(Color.white)
                }.padding()
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2))
                    .padding()
                NavigationLink(destination: PictureWall(AllPostList: [], AllUserData: [], userGetProfile:self.userConGetProfile), isActive: $showProfileView){
                Button(action:{
                    ApiControl.shared.LoginAPI(LoginUserName: self.un, LoginPassWord: self.pd){
                        (result) in
                        switch result {
                        case .success(let userProfile):
                            self.usertokenID = userProfile.sessionToken
                            self.userID = userProfile._embedded.user.id
                            userDefaults.set(userProfile._embedded.user.id, forKey: "userLoginAPPID")
                            print("Loing Get the AppID:" + userDefaults.string(forKey: "userLoginAPPID")!)
                            ApiControl.shared.GetProfileAPI(UserID: self.userID){
                                (result) in
                                switch result{
                                case .success(let userGetProfile):
                                    self.userConGetProfile = userGetProfile
                                    self.showProfileView = true
                                case .failure( _):
                                    break
                                }
                            }
                        case .failure( _):
                            self.showAlert = true
                        }
                    }
                    
                }){
                    Text("Login")
                        .font(.custom("Times", size: 22))
                        .frame(width:320)
                        .foregroundColor(.white)
                }.padding()
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2))
                    .padding()
                .alert(isPresented: $showAlert){() -> Alert in
                return Alert(title: Text("Username or Password Error!!"))}
                }
                VStack(alignment: .leading){
                    Text("No Account?")
                        .font(.custom("Times", size: 17))
                        .foregroundColor(.white)
                        .offset(x:40)
                    HStack{
                        NavigationLink(destination: RegisterView()){
                            Text("Register")
                                .font(.custom("Times", size: 22))
                                .frame(width:100)
                                .foregroundColor(.white)
                        }.padding()
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2))
                            .padding()
                        NavigationLink(destination: ForgetPassword()){
                            Text("Forget Password")
                                .font(.custom("Times", size: 22))
                                .frame(width:150)
                                .foregroundColor(.white)
                        }.padding()
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2))
                            .padding()
                    }
                }
                
            }.background(
                Image("Background3")
                    .blur(radius: 15)
            )
                .offset(y:-80)
                .padding()
            .onAppear{
                self.AutoLogin()
                if self.titleOpacity != 0{
                    self.titleOpacity = 0
                    withAnimation (Animation.linear(duration: 2)){
                       self.titleOpacity += 1
                    }
                }
                else{
                    withAnimation (Animation.linear(duration: 2)){
                       self.titleOpacity += 1
                    }
                }
            }
        }
    }
    
    func AutoLogin() -> Void {
        if userDefaults.string(forKey: "userLoginAPPID") != nil && userDefaults.string(forKey: "userLoginAPPID")! != "unknown" {
            ApiControl.shared.GetProfileAPI(UserID: userDefaults.string(forKey: "userLoginAPPID")!){
                (result) in
                switch result{
                case .success(let userGetProfile):
                    self.userConGetProfile = userGetProfile
                    self.showProfileView = true
                case .failure( _):
                    break
                }
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(userConGetProfile: UGProfileDec(id: "", status: "", created: "", profile: Profile(firstName: "", lastName: "", email: "", login: "", birthday: "", profileUrl: "")))
    }
}

struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { placeholder }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
        }
    }
}

struct CustomSecureField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { placeholder }
            SecureField("", text: $text)
        }
    }
}
