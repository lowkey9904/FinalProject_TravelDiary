//
//  ModifyProfileView.swift
//  SheetDB_Hw3
//
//  Created by Joker on 2020/6/8.
//  Copyright © 2020 ntoucs. All rights reserved.
//

import SwiftUI

struct ModifyProfileView: View {
    @State private var fn = ""
    @State private var ln = ""
    @State private var email = ""
    @State private var bd = ""
    @State private var pfU = ""
    @State private var showAlertError = false
    @State private var showSelectPhoto = false
    @State private var selectImage: UIImage?
    @State private var content = ""
    @State var userID:String
    @ObservedObject var photoData = PhotoData()
    @Environment(\.presentationMode) var MPpresentationMode: Binding<PresentationMode>
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color(red: 245/255, green: 230/255, blue: 170/255), Color.white]), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1))
        .edgesIgnoringSafeArea(.vertical)
            .overlay(
        VStack{
            Form{
                HStack{
                    Image(systemName: "person")
                        .foregroundColor(Color.black)
                    CustomTextField(placeholder: Text("Lastname").foregroundColor(.gray), text:$ln)
                        .foregroundColor(.black)
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.black, lineWidth: 2))
                .padding()
                HStack{
                    Image(systemName: "person")
                        .foregroundColor(Color.black)
                    CustomTextField(placeholder: Text("Firstname").foregroundColor(.gray), text: $fn)
                        .foregroundColor(.black)
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.black, lineWidth: 2))
                .padding()
                Button(action: {
                    self.showSelectPhoto = true
                }) {
                    Group {
                        if selectImage != nil {
                            Image(uiImage: selectImage!)
                                .resizable()
                                .renderingMode(.original)
                                //.frame(width:UIScreen.main.bounds.width - 100, height: 250)
                                .scaledToFill()
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                //.frame(width:UIScreen.main.bounds.width - 100, height: 250)
                                .scaledToFill()
                        }
                    }
                    .scaledToFill()
                    //.frame(width: 310, height: 310)
                    .clipped()
                    .foregroundColor(.gray)
                    Text("Select Profile Photo.")
                        .foregroundColor(.gray)
                }.padding()
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.black, lineWidth: 2))
                .padding()
                HStack{
                    Image(systemName: "envelope")
                        .foregroundColor(Color.black)
                    CustomTextField(placeholder: Text("Email").foregroundColor(.gray), text: $email)
                        .foregroundColor(.black)
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.black, lineWidth: 2))
                .padding()
                HStack{
                    Image(systemName: "clock")
                        .foregroundColor(Color.black)
                    CustomTextField(placeholder: Text("Birthday").foregroundColor(.gray), text: $bd)
                        .foregroundColor(.black)
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.black, lineWidth: 2))
                .padding()
            }
                .onAppear{
                    UITableView.appearance().separatorColor = .clear
                    UITableView.appearance().backgroundColor = .clear
                    UITableViewCell.appearance().backgroundColor = .clear
            }
            .sheet(isPresented: $showSelectPhoto) {
                ImagePickerController(selectImage: self.$selectImage, showSelectPhoto: self.$showSelectPhoto)}
            Button("Submit"){
                if self.selectImage != nil {
                    ApiControl.shared.uploadImage(uiImage: self.selectImage!){
                        (result) in
                        switch result {
                        case .success(let uploadImageUrl):
                            self.pfU = uploadImageUrl
                            ApiControl.shared.ModifyProfileAPI(userID: self.userID, Mfirstname: self.fn, Mlastname: self.ln, Mprofileurl: self.pfU, Mbirthday: self.bd){
                                (result) in
                                switch result{
                                case .success( _):
                                    print("modify success!!")
                                    DispatchQueue.main.async {
                                        self.MPpresentationMode.wrappedValue.dismiss()
                                    }
                                case .failure( _):
                                    self.showAlertError = true
                                }
                            }
                        case .failure( _):
                            print("Cannot get the image url.")
                        }
                    }
                }
                else {
                    ApiControl.shared.ModifyProfileAPI(userID: self.userID, Mfirstname: self.fn, Mlastname: self.ln, Mprofileurl: self.pfU, Mbirthday: self.bd){
                        (result) in
                        switch result{
                        case .success( _):
                            print("modify success!!")
                            DispatchQueue.main.async {
                                self.MPpresentationMode.wrappedValue.dismiss()
                            }
                        case .failure( _):
                            self.showAlertError = true
                        }
                    }
                }
            }.font(.custom("Times", size: 30))
                .frame(width:310)
                .foregroundColor(.black)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.black, lineWidth: 2))
                .padding()
                .alert(isPresented: $showAlertError){() -> Alert in
                    return Alert(title: Text("修改錯誤 請重新輸入!!"))
            }
        }.navigationBarTitle(Text("Modify Profile"), displayMode: .inline))
    }
}


struct ModifyProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ModifyProfileView(userID: "00u941uf62qbYVvo94x6")
    }
}

