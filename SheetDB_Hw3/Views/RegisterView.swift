//
//  RegisterView.swift
//  LoginRegister
//
//  Created by Joker on 2020/4/17.
//  Copyright © 2020 ntoucs. All rights reserved.
//

import SwiftUI

struct RegisterView: View {
    @State private var fn = ""
    @State private var ln = ""
    @State private var email = ""
    @State private var un = ""
    @State private var bd = ""
    @State private var pfU = ""
    @State private var pd = ""
    @State private var pd2 = ""
    @State private var rq = ""
    @State private var ra = ""
    @State private var userID = ""
    @State private var showAlert = false
    @State private var showSelectPhoto = false
    @State private var selectImage: UIImage?
    @ObservedObject var photoData = PhotoData()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    init(){
        UITableView.appearance().separatorColor = .clear
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        UINavigationBar.appearance().tintColor = UIColor.black
    }
    
    var body: some View {
        VStack{
            List{
                HStack{
                    Image(systemName: "person.badge.plus")
                        .foregroundColor(Color.white)
                    CustomTextField(placeholder: Text("Username").foregroundColor(Color(red:193/255, green:193/255, blue:193/255)), text:$un)
                        .foregroundColor(.white)
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2))
                .padding()
                HStack{
                    Image(systemName: "person")
                        .foregroundColor(Color.white)
                    CustomTextField(placeholder: Text("Firstname").foregroundColor(Color(red:193/255, green:193/255, blue:193/255)), text:$fn)
                        .foregroundColor(.white)
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2))
                .padding()
                HStack{
                    Image(systemName: "person")
                        .foregroundColor(Color.white)
                    CustomTextField(placeholder: Text("Lastname").foregroundColor(Color(red:193/255, green:193/255, blue:193/255)), text: $ln)
                        .foregroundColor(.white)
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2))
                .padding()
                Button(action: {
                    self.showSelectPhoto = true
                }) {
                    Group {
                        if selectImage != nil {
                            Image(uiImage: selectImage!)
                                .resizable()
                                .renderingMode(.original)
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                        }
                    }
                    .scaledToFill()
                    .frame(width: 310, height: 310)
                    .clipped()
                    .foregroundColor(.white)
                    Text("Select Profile Photo")
                        .foregroundColor(Color(red:193/255, green:193/255, blue:193/255))
                }.padding()
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
                HStack{
                    Image(systemName: "clock")
                        .foregroundColor(Color.white)
                    CustomTextField(placeholder: Text("Birthday").foregroundColor(Color(red:193/255, green:193/255, blue:193/255)), text: $bd)
                        .foregroundColor(.white)
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2))
                .padding()
                HStack{
                    Image(systemName: "questionmark.circle")
                        .foregroundColor(Color.white)
                    CustomTextField(placeholder: Text("Security Question").foregroundColor(Color(red:193/255, green:193/255, blue:193/255)),text:$rq)
                        .foregroundColor(.white)
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2))
                .padding()
                HStack{
                    Image(systemName: "questionmark.circle.fill")
                        .foregroundColor(Color.white)
                    CustomTextField(placeholder: Text("Security Answer").foregroundColor(Color(red:193/255, green:193/255, blue:193/255)),text:$ra)
                        .foregroundColor(.white)
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2))
                .padding()
                HStack{
                    Image(systemName: "lock")
                        .foregroundColor(Color.white)
                    CustomSecureField(placeholder: Text("Password").foregroundColor(Color(red:193/255, green:193/255, blue:193/255)),text:$pd)
                        .foregroundColor(.white)
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2))
                .padding()
                HStack{
                    Image(systemName: "lock.fill")
                        .foregroundColor(Color.white)
                    CustomSecureField(placeholder: Text("Confirm Password").foregroundColor(Color(red:193/255, green:193/255, blue:193/255)),text:$pd2)
                        .foregroundColor(.white)
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2))
                .padding()
            }.background(Image("Background3")
                .blur(radius: 15)
                .opacity(0.8))
                .sheet(isPresented: $showSelectPhoto) {
                    ImagePickerController(selectImage: self.$selectImage, showSelectPhoto: self.$showSelectPhoto)
            }
            Button("Submit"){
                if self.pd != self.pd2{
                    self.showAlert = true
                }
                else{
                    if self.selectImage != nil {
                        ApiControl.shared.uploadImage(uiImage: self.selectImage!){
                            (result) in
                            switch result{
                            case .success(let uploadImageUrl):
                                self.pfU = uploadImageUrl
                                ApiControl.shared.RegisterAPI(Rfirstname: self.fn, Rlastname: self.ln, Remail: self.email, Rlogin: self.un, Rbirthday: self.bd, Rprofilurl: self.pfU, Rpassword: self.pd){
                                    (result) in
                                    switch result {
                                    case .success(let userstatus):
                                        ApiControl.shared.ChangeRecoveryQuestionAPI(UserID: userstatus.id, UserPassword: self.pd, UserRQ: self.rq, UserRA: self.ra){
                                            (result) in
                                            switch result {
                                            case .success( _):
                                                print("CRQ changed.")
                                                self.presentationMode.wrappedValue.dismiss()
                                            case .failure( _):
                                                print("CRQ Error.")
                                                break
                                            }
                                        }
                                    case .failure( _):
                                        self.showAlert = true
                                    }
                                }
                            case .failure( _):
                                ApiControl.shared.RegisterAPI(Rfirstname: self.fn, Rlastname: self.ln, Remail: self.email, Rlogin: self.un, Rbirthday: self.bd, Rprofilurl: self.pfU, Rpassword: self.pd){
                                    (result) in
                                    switch result {
                                    case .success(let userstatus):
                                        ApiControl.shared.ChangeRecoveryQuestionAPI(UserID: userstatus.id, UserPassword: self.pfU, UserRQ: self.rq, UserRA: self.ra){
                                            (result) in
                                            switch result {
                                            case .success( _):
                                                print("CRQ changed.")
                                                self.presentationMode.wrappedValue.dismiss()
                                            case .failure( _):
                                                print("CRQ Error.")
                                                break
                                            }
                                        }
                                    case .failure( _):
                                        self.showAlert = true
                                    }
                                }
                                print("Cannot get the image url.")
                            }
                        }
                    }
                    else {
                        print("No selectImage!!")
                        ApiControl.shared.RegisterAPI(Rfirstname: self.fn, Rlastname: self.ln, Remail: self.email, Rlogin: self.un, Rbirthday: self.bd, Rprofilurl: self.pfU, Rpassword: self.pd){
                            (result) in
                            switch result {
                            case .success(let userstatus):
                                ApiControl.shared.ChangeRecoveryQuestionAPI(UserID: userstatus.id, UserPassword: self.pfU, UserRQ: self.rq, UserRA: self.ra){
                                    (result) in
                                    switch result {
                                    case .success( _):
                                        print("CRQ changed.")
                                        self.presentationMode.wrappedValue.dismiss()
                                    case .failure( _):
                                        print("CRQ Error.")
                                        break
                                    }
                                }
                            case .failure( _):
                                self.showAlert = true
                            }
                        }
                        
                    }
                }
            }.font(.custom("Times", size: 30))
                .frame(width:320)
                .foregroundColor(.white)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2))
                .padding()
                .alert(isPresented: $showAlert){() -> Alert in
                    return Alert(title: Text("Register Error!!"))
            }
        }
    }
}
struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
