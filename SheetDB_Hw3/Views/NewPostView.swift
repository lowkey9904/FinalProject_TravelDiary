//
//  NewPostView.swift
//  SheetDB_Hw3
//
//  Created by Joker on 2020/5/9.
//  Copyright © 2020 ntoucs. All rights reserved.
//

import SwiftUI
import PhotoLibraryPicker
import Photos

struct NewPostView: View {
    @State var userID:String
    @State var userFN:String
    @State var userLN:String
    @State private var content = ""
    @State private var nowTime = ""
    @State private var location = ""
    @State var selected : [SelectedImages] = []
    @State var showActionSheet: Bool = false
    @State var show = false
    @ObservedObject var imageModel = ImageModel()
    @ObservedObject var imageModel2 = ImageModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color(red: 245/255, green: 230/255, blue: 170/255), Color.white]), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1))
        .edgesIgnoringSafeArea(.vertical)
            .overlay(
        VStack{
            Form{
                if !self.selected.isEmpty{
                    ScrollView(.horizontal) {
                        HStack{
                            ForEach(self.selected,id: \.self){i in
                                Image(uiImage: i.image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: UIScreen.main.bounds.width - 40, height: 250)
                                    .cornerRadius(5)
                            }
                            }.padding()
                        .frame(height: 270)
                    }
                }
                else{
                    Image(systemName: "photo.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width - 40, height: 250)
                    .cornerRadius(5)
                }
                HStack{
                    Button(action: {
                        self.selected.removeAll()
                        self.show.toggle()
                        
                    }) {
                        HStack{
                        Image(systemName: "photo.on.rectangle")
                        Text("Select Image..")
                            Spacer()
                        }.foregroundColor(.black)
                    }
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.black, lineWidth: 2))
                    .padding()
                    .sheet(isPresented: self.$show){
                        CustomPicker(selected: self.$selected, show: self.$show)
                    }
                }
                NavigationLink(destination: LocationView(location: self.$location)){
                    HStack{
                    Image(systemName: "map")
                        .renderingMode(.original)
                        if self.location != ""{
                            Text(self.location)
                        }else{
                            Text("Location.. ")
                        }
                    }.foregroundColor(.black)
                }.padding()
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.black, lineWidth: 2))
                    .padding()
                MultilineTextField("Content", text: self.$content)
                    .foregroundColor(.black)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.black, lineWidth: 2))
                    .padding()
            }
            Button(action:{
                if self.selected.count == 1{
                    self.imageModel.GetImageURL(uiImage: self.selected[0].image, userID: self.userID, userName: self.userFN + " " + self.userLN, time: self.GetTime(), content: self.content, location: self.location)
                }
                else if self.selected.count == 2{
                    self.imageModel.GetImageURL2(uiImage: self.selected[0].image, uiImage2:  self.selected[1].image,  userID: self.userID, userName: self.userFN + " " + self.userLN, time: self.GetTime(), content: self.content, location: self.location)
                }
                else if self.selected.count == 3{
                    self.imageModel.GetImageURL3(uiImage: self.selected[0].image, uiImage2:  self.selected[1].image, uiImage3: self.selected[2].image,  userID: self.userID, userName: self.userFN + " " + self.userLN, time: self.GetTime(), content: self.content, location: self.location)
                }
                print(self.imageModel.ImageURL)
            }){
                Text("Submit")
                    .font(.custom("Times", size: 30))
                    .frame(width:320)
                    .foregroundColor(.black)
            }
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.black, lineWidth: 2))
            .padding()
        }.navigationBarTitle("New Post", displayMode: .inline)
        .onReceive(self.imageModel.$finish) { (value) in
            if value == true{
                self.presentationMode.wrappedValue.dismiss()
            }
        })
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

struct CustomPicker: View {
    @Binding var selected : [SelectedImages]
    @State var grid : [[Images]] = []
    @Binding var show : Bool
    @State var disabled = false
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color(red: 245/255, green: 230/255, blue: 170/255), Color.white]), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1))
        .edgesIgnoringSafeArea(.vertical)
            .overlay(
        GeometryReader{_ in
            VStack{
                if !self.grid.isEmpty{
                    HStack{
                        Text("Pick Images(At most three.)")
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding(.leading)
                    .padding(.top)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        VStack(spacing: 20){
                            
                            ForEach(self.grid,id: \.self){i in
                                HStack{
                                    ForEach(i,id: \.self){j in
                                        Card(data: j, selected: self.$selected)
                                    }
                                }
                            }
                        }
                        .padding(.bottom)
                    }.padding()
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.black, lineWidth: 2))
                    .padding()
                    
                    Button(action: {
                        self.show.toggle()
                    }) {
                        Text("Select")
                            .foregroundColor(.white)
                            .padding(.vertical,10)
                            .frame(width: UIScreen.main.bounds.width / 2)
                    }
                    .background(Color.black)
                    .clipShape(Capsule())
                    .padding(.bottom)
                    .disabled((self.selected.count > 3 || self.selected.count == 0) ? true : false)
                }
                else{
                    if self.disabled{
                        Text("Enable Storage Access In Settings.")
                    }
                    if self.grid.count == 0{
                        Indicator()
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.height/3*2)
            .cornerRadius(12)
            }.padding()
//            .onTapGesture {
//                self.show.toggle()
//            }
            .onAppear {
                PHPhotoLibrary.requestAuthorization { (status) in
                    if status == .authorized{
                        self.getAllImages()
                        self.disabled = false
                    }
                    else{
                        print("not authorized")
                        self.disabled = true
                    }
                }
        })
    }
    
    func getAllImages(){
        
        let opt = PHFetchOptions()
        opt.includeHiddenAssets = false
        
        let req = PHAsset.fetchAssets(with: .image, options: .none)
        
        DispatchQueue.global(qos: .background).async {
            
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            
            // New Method For Generating Grid Without Refreshing....
            
            for i in stride(from: 0, to: req.count, by: 3){
                
                var iteration : [Images] = []
                
                for j in i..<i+3{
                    if j < req.count{
                        PHCachingImageManager.default().requestImage(for: req[j], targetSize: CGSize(width: 150, height: 150), contentMode: .default, options: options) { (image, _) in
                            
                            let data1 = Images(image: image!, selected: false, asset: req[j])
                            iteration.append(data1)
                        }
                    }
                }
                self.grid.append(iteration)
            }
            
        }
    }
}

struct Card : View {
    
    @State var data : Images
    @Binding var selected : [SelectedImages]
    
    var body: some View{
        
        ZStack{
            Image(uiImage: self.data.image)
                .resizable()
                .frame(width:100, height: 100)
            
            if self.data.selected{
                ZStack{
                    Color.black.opacity(0.4)
                       .frame(width:100, height: 100)
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.blue)
                    .offset(x: 50, y: 40)
                }
            }
        }
        .frame(width: (UIScreen.main.bounds.width - 80) / 3, height: 90)
        .onTapGesture {
            if !self.data.selected{
                self.data.selected = true
                DispatchQueue.global(qos: .background).async {
                    
                    let options = PHImageRequestOptions()
                    options.isSynchronous = true

                    PHCachingImageManager.default().requestImage(for: self.data.asset, targetSize: .init(), contentMode: .default, options: options) { (image, _) in
                        
                        self.selected.append(SelectedImages(asset: self.data.asset, image: image!))
                    }
                }
            }
            else{
                for i in 0..<self.selected.count{
                    if self.selected[i].asset == self.data.asset{
                        self.selected.remove(at: i)
                        self.data.selected = false
                        return
                    }
                }
            }
        }
    }
}

struct Indicator : UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIActivityIndicatorView  {
        
        let view = UIActivityIndicatorView(style: .large)
        view.startAnimating()
        return view
    }
    
    func updateUIView(_ uiView:  UIActivityIndicatorView, context: Context) {
        
        
    }
}

struct Images: Hashable {
    
    var image : UIImage
    var selected : Bool
    var asset : PHAsset
}

struct SelectedImages: Hashable{
    
    var asset : PHAsset
    var image : UIImage
}

