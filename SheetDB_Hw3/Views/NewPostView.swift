//
//  NewPostView.swift
//  SheetDB_Hw3
//
//  Created by Joker on 2020/5/9.
//  Copyright © 2020 ntoucs. All rights reserved.
//

import SwiftUI
import PhotoLibraryPicker

struct NewPostView: View {
    @State var userID:String
    @State var userFN:String
    @State var userLN:String
    @State private var content = ""
    @State private var location = ""
    @State private var nowTime = ""
    @State private var selectImage: UIImage?
    @State private var selectImage2: UIImage?
    @ObservedObject var imageModel = ImageModel()
    @ObservedObject var imageModel2 = ImageModel()
    @State var showActionSheet: Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack{
            List{
                Button(action: {
                    self.showActionSheet.toggle()
                }) {
                    VStack{
                        Group {
                            if selectImage != nil {
                                Image(uiImage: selectImage!)
                                    .resizable()
                                    .renderingMode(.original)
                            } else {
                                Image(systemName: "photo")
                                    .resizable()
                            }
                        }.sheet(isPresented: self.$showActionSheet) {
                            ImagePickerController(selectImage: self.$selectImage, showSelectPhoto: self.$showActionSheet)
                        }
                        .scaledToFill()
                        .frame(width: 310, height: 310)
                        .clipped()
                        .foregroundColor(.gray)
                        Text("Select Picture")
                            .foregroundColor(.gray)
                    }
                }.padding()
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.black, lineWidth: 2))
                    .padding()
                Button(action: {
                    self.showActionSheet.toggle()
                }) {
                    VStack{
                        Group {
                            if selectImage2 != nil {
                                Image(uiImage: selectImage2!)
                                    .resizable()
                                    .renderingMode(.original)
                            } else {
                                Image(systemName: "photo")
                                    .resizable()
                            }
                        }.sheet(isPresented: self.$showActionSheet) {
                            ImagePickerController(selectImage: self.$selectImage2, showSelectPhoto: self.$showActionSheet)
                        }
                        .scaledToFill()
                        .frame(width: 310, height: 310)
                        .clipped()
                        .foregroundColor(.gray)
                        Text("Select Picture")
                            .foregroundColor(.gray)
                    }
                }.padding()
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.black, lineWidth: 2))
                    .padding()
                MultilineTextField("Content", text: self.$content)
                    .foregroundColor(.black)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.black, lineWidth: 2))
                    .padding()
                MultilineTextField("Location", text: self.$location)
                .foregroundColor(.black)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.black, lineWidth: 2))
                .padding()
                
            }
            Button(action:{
                if self.selectImage != nil && self.selectImage2 != nil{
                    self.imageModel.GetImageURL2(uiImage: self.selectImage!, uiImage2: self.selectImage2!, userID: self.userID, userName: self.userFN + " " + self.userLN, time: self.GetTime(), content: self.content, location: self.location)
                }
                else{
                    if self.selectImage != nil{
                        self.imageModel.GetImageURL(uiImage: self.selectImage!,  userID: self.userID, userName: self.userFN + " " + self.userLN, time: self.GetTime(), content: self.content, location: self.location)
                    }else if self.selectImage2 != nil{
                        self.imageModel.GetImageURL(uiImage: self.selectImage2!,  userID: self.userID, userName: self.userFN + " " + self.userLN, time: self.GetTime(), content: self.content, location: self.location)
                    }else{
                        print("wait")
                    }
                }
                print(self.imageModel.ImageURL)
                //if self.selectImage2 != nil{
                //    self.imageModel2.GetImageURL(uiImage: self.selectImage2!)
                //}
                
            }){
                Text("Submit")
                    .font(.custom("Times", size: 30))
                    .frame(width:320)
                    .foregroundColor(.black)
            }
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.black, lineWidth: 2))
            .padding()
        }
        .onReceive(self.imageModel.$finish) { (value) in
            if value == true{
                self.presentationMode.wrappedValue.dismiss()
            }
        }
        
    }
    func GetTime() -> String{
        let date = Date()
        let calendar = Calendar.current
        //let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        var StringMon = String(month)
        var StringDay = String(day)
        var StringHour = String(hour)
        var StringMin = String(minutes)
        
        if month < 10{
            StringMon = "0" + String(month)
        }
        if day < 10{
            StringDay = "0" + String(day)
        }
        if hour < 10{
            StringHour = "0" + String(hour)
        }
        if minutes < 10{
            StringMin = "0" + String(minutes)
        }
        
        return StringMon + "/" + StringDay + " " + StringHour + ":" + StringMin
    }
}

struct NewPostView_Previews: PreviewProvider {
    static var previews: some View {
        NewPostView(userID: "", userFN: "", userLN: "")
    }
}
