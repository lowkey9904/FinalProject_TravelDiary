//
//  ListRow.swift
//  SheetDB_Hw3
//
//  Created by Joker on 2020/5/12.
//  Copyright © 2020 ntoucs. All rights reserved.
//

import SwiftUI
import URLImage

struct ProfileListRow: View {
    
    let Post: MyData
    
    var body: some View {
        HStack{
            if Post.pictureURL != ""{
                URLImage(URL(string: Post.pictureURL)!, placeholder: { (_) in
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFill()
                        .frame(width:50, height: 50)
                        .cornerRadius(5)
                        //.shadow(radius: 30)
                }) { (proxy) in
                    proxy.image
                        .resizable()
                        .scaledToFill()
                        .frame(width:50, height: 50)
                        .cornerRadius(5)
                        //.shadow(radius: 30)
                }
                .padding(.bottom, 30)
            }
            VStack(alignment: .leading){
                Text(Post.content)
                    .lineLimit(nil)
                    .padding(.bottom, 20)
                Text(Post.time)
                
            }.offset(y:-15)
        }.padding()
            .frame(height:100)
    }
}

struct ProfileListRow_Previews: PreviewProvider {
    static var previews: some View {
        ProfileListRow(Post: MyData(userID: "00u97gz2xh3GgXDIm4x6", userName: "Lawrence Li", time: "05/09 20:53", content: "This made most viral? That's not very punk rock, but whatever, send me whatever you got.", pictureURL: "https://i.imgur.com/5PgyIOe.png", pictureURL2: "", location: "New Taipei City"))
    }
}
