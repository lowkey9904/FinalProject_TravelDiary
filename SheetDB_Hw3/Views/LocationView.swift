//
//  LocationView.swift
//  SheetDB_Hw3
//
//  Created by Joker on 2020/6/6.
//  Copyright © 2020 ntoucs. All rights reserved.
//

import SwiftUI
import Foundation
import CoreData
import MapKit

struct LocationView: View {
    @ObservedObject var locationManger = LocationManager.shared
    @State var searchText = ""
    @Binding var location:String
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color(red: 245/255, green: 230/255, blue: 170/255), Color.white]), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1))
        .edgesIgnoringSafeArea(.vertical)
            .overlay(
        VStack{
            HStack{
                SearchBar(text: $searchText)
                Button(action:{
                    self.locationManger.getLocation(searchText: self.searchText)
                }){
                    Text("Search")
                }.offset(y: -1)
            }.padding(.horizontal)
            List(locationManger.mapItems.indices, id: \.self){
                (index) in
                Button(action:{
                    self.location = self.locationManger.mapItems[index].name ?? ""
                    //print(self.location)
                    self.presentationMode.wrappedValue.dismiss()}){
                    Text(self.locationManger.mapItems[index].name ?? "")
                        .foregroundColor(.black)
                }
            }
        }.onAppear{
            self.locationManger.mapItems.removeAll() //清空前一輪結果
        })
    }
}


