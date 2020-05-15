//
//  ForgetPassword.swift
//  LoginRegister
//
//  Created by Joker on 2020/4/20.
//  Copyright © 2020 ntoucs. All rights reserved.
//

import SwiftUI

struct ForgetPassword: View {
    @State private var userID = ""
    @State private var un = ""
    @State private var email = ""
    @State private var showAlertError = false
    @State private var showWebpage = false
    @State private var fpURL = ""
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack{
            Spacer()
            HStack{
                Image(systemName: "person.badge.plus")
                    .foregroundColor(Color.white)
                CustomTextField(placeholder: Text("Username").foregroundColor(Color(red:193/255, green:193/255, blue:193/255)), text: $un)
                    .foregroundColor(.white)
            }
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2))
            .padding()
            HStack{
                Image(systemName: "envelope")
                    .foregroundColor(Color.white)
                CustomTextField(placeholder: Text("Email").foregroundColor(Color(red:193/255, green:193/255, blue:193/255)), text: $email)
                    .foregroundColor(.white)
            }
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2))
            .padding()
            Spacer()
            Button("Submit"){
                ApiControl.shared.GetAllUserAPI(UserName: self.un, UserEmail: self.email){
                    (result) in
                    switch result{
                    case .success(let userID):
                        self.userID = userID
                        ApiControl.shared.ForgetPasswordAPI(UserID: self.userID){
                            (result) in
                            switch result {
                            case .success(let fpURL):
                                self.fpURL = fpURL
                                self.showWebpage = true
                            case .failure( _):
                                print("Cannot get the FPurl.")
                            }
                        }
                    case .failure( _):
                        self.showAlertError = true
                    }
                }}.font(.custom("Times", size: 30))
                .frame(width:320)
                .foregroundColor(.white)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2))
                .padding()
                .alert(isPresented: $showAlertError){() -> Alert in
                    return Alert(title: Text("Username or Email Error!!"))
            }.sheet(isPresented: $showWebpage) {
                SafariView(url: URL(string: self.fpURL)!)
            }
        }.background(Image("Background3")
        .blur(radius: 15)
        .opacity(0.8))
    }
}

struct ForgetPassword_Previews: PreviewProvider {
    static var previews: some View {
        ForgetPassword()
    }
}


