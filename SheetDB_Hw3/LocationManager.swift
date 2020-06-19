//
//  LocationManager.swift
//  SheetDB_Hw3
//
//  Created by Joker on 2020/6/6.
//  Copyright © 2020 ntoucs. All rights reserved.
//

import SwiftUI
import CoreLocation
import MapKit

class LocationManager: NSObject, ObservableObject{
    static let shared = LocationManager()
    
    let manager = CLLocationManager()
    var searchText = ""
    @Published var mapItems = [MKMapItem]()
    
    override init() {
        //self._mapItems = searchText
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func getLocation(searchText: String){
        self.searchText = searchText
        //print("GetLocation: " + self.searchText)
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = MKCoordinateRegion(center: locations.last!.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        userDefaults.set(String(locations.last!.coordinate.latitude), forKey: "latitude")
        userDefaults.set(String(locations.last!.coordinate.longitude), forKey: "longitude")
        print(locations.last!.coordinate.latitude, locations.last!.coordinate.longitude)
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if let mapItems = response?.mapItems {
                self.mapItems = mapItems
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("GetLocation Error.")
    }
}
