//
//  AttractionsView.swift
//  SheetDB_Hw3
//
//  Created by Joker on 2020/6/19.
//  Copyright © 2020 ntoucs. All rights reserved.
//

import SwiftUI
import CoreLocation

struct AttractionsView: View {
    @ObservedObject var locationManger = LocationManager.shared
    @State var myAttractions:Attractions
    @State var latitude = ""
    @State var longitude = ""
    var body: some View {
        NavigationView{
            LinearGradient(gradient: Gradient(colors: [Color(red: 245/255, green: 230/255, blue: 170/255), Color.white]), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1))
                .edgesIgnoringSafeArea(.vertical)
                .overlay(
                    VStack(alignment: .leading){
                        if userDefaults.string(forKey: "latitude") != nil && userDefaults.string(forKey: "longitude") != nil{
                            NavigationLink(destination: SafariView(url: URL(string: ("http://maps.google.com/?q=" + self.latitude + "," + self.longitude))!)){
                            Text("現在緯度：" + self.latitude + ", " + self.longitude)
                                .font(.system(size: 10))
                                .padding(.horizontal)
                            }
                        }
                        else{
                            Text("現在緯度：unknown, unknown")
                                .font(.system(size: 15))
                                .padding(.horizontal)
                        }
                        List{
                            ForEach(0..<self.myAttractions.data.count, id: \.self){ (att) in
                                NavigationLink(destination: SafariView(url: URL(string: self.myAttractions.data[att].url)!)){
                                    AttractionsRow(attName: self.myAttractions.data[att].name, attAdd: self.myAttractions.data[att].address)
                                }
                            }
                        }
                    }.navigationBarTitle("Nearby Attractions", displayMode: .inline)
            )
        }
            .onAppear {
                self.locationManger.getLocation(searchText: "")
                if userDefaults.string(forKey: "latitude") != nil && userDefaults.string(forKey: "longitude") != nil{
                    self.latitude = userDefaults.string(forKey: "latitude")!
                    self.longitude = userDefaults.string(forKey: "longitude")!
                    ApiControl.shared.GetYourAttractions(lat: userDefaults.string(forKey: "latitude")!, long: userDefaults.string(forKey: "longitude")!){
                        (result) in
                        switch result{
                        case .success(let Attractions):
                            self.myAttractions = Attractions
                        case .failure( _):
                            print("Get Attractions Error.")
                        }
                    }
                }
        }
    }
}

struct AttractionsView_Previews: PreviewProvider {
    static var previews: some View {
        AttractionsView(myAttractions: Attractions(total: 0, data: []))
    }
}
