//
//  PostRow.swift
//  SheetDB_Hw3
//
//  Created by Joker on 2020/5/10.
//  Copyright © 2020 ntoucs. All rights reserved.
//

import SwiftUI
import URLImage

struct PostRow: View {
    
    let Post: MyData
    
    var body: some View {
        
        VStack(alignment: .leading){
            HStack{
                Text(Post.userName)
                    .bold()
                    .font(.custom("Times", size: 25))
                Spacer()
            }.padding(10)
            HStack{
                Image(systemName: "location")
                Text(Post.location)
                    .font(.custom("Times", size: 20))
                Spacer()
            }.padding(10)
            if Post.pictureURL != ""{
                if Post.pictureURL2 != ""{
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack{
                            URLImage(URL(string: Post.pictureURL)!) { (proxy) in
                                proxy.image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width:400, height: 400)
                                    .cornerRadius(5)
                                    .shadow(radius: 30)
                            }
                            URLImage(URL(string: Post.pictureURL2)!) { (proxy) in
                                proxy.image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width:400, height: 400)
                                    .cornerRadius(5)
                                    .shadow(radius: 30)
                            }
                        }.frame(height: 400)
                    }.padding(.bottom, 30)
                    
                }else{
                    URLImage(URL(string: Post.pictureURL)!, placeholder: { (_) in
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFill()
                            .frame(width:400, height: 400)
                            .cornerRadius(5)
                            .shadow(radius: 30)
                    }) { (proxy) in
                        proxy.image
                            .resizable()
                            .scaledToFill()
                            .frame(width:400, height: 400)
                            .cornerRadius(5)
                            .shadow(radius: 30)
                    }
                    .padding(.bottom, 30)
                }
            }
            
            Text(Post.content)
                .padding(5)
                //.frame(height: 120)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
            Text(Post.time)
                .padding(10)
        }.frame(width:400)
            .font(.custom("Times", size: 23))
            .lineLimit(nil)
            .multilineTextAlignment(.leading)
            .padding(.vertical, 30)
    }
}

struct PostRow_Previews: PreviewProvider {
    static var previews: some View {
        PostRow(Post: MyData(userID: "00u97gz2xh3GgXDIm4x6", userName: "Lawrence Li", time: "05/09 20:53", content: "This made most viral? That's not very punk rock, but whatever, send me whatever you got.", pictureURL: "https://i.imgur.com/5PgyIOe.png", pictureURL2: "https://i.imgur.com/B3kISlX.jpg", location: "New Taipei City"))
    }
}
