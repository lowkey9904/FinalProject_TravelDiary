//
//  ImageModel.swift
//  SheetDB_Hw3
//
//  Created by Joker on 2020/5/12.
//  Copyright © 2020 ntoucs. All rights reserved.
//

import Foundation
import Combine
import UIKit

class ImageModel: ObservableObject {
    @Published var ImageURL = String()
    //@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var cancellable: AnyCancellable?
        @Published var finish = false
    func GetImageURL(uiImage: UIImage, userID: String, userName: String, time: String, content:String, location:String) {
        if uiImage != nil {
            cancellable = ApiControl.shared.uploadImagePublisher(uiImage: uiImage)
                .sink(receiveCompletion: { (completion) in
                    if case .failure = completion {
                        print("error")
                    }
                }) {[weak self] (value) in
                    guard let self = self else { return }
                    self.ImageURL = value.data.link
                    print(self.ImageURL)
                    ApiControl.shared.NewPostAPI(userID: userID, userName: userName, time: time, content: content, pictureURL: self.ImageURL, pictureURL2: "", location: location){
                        (result) in
                        switch result {
                        case .success( _):
                            DispatchQueue.main.async {
                                self.finish = true
                            }
                            break
                        case .failure( _):
                            break
                        }
                    }
            }
        }
    }
    func GetImageURL2(uiImage: UIImage, uiImage2: UIImage, userID: String, userName: String, time: String, content:String, location:String) {
        if uiImage != nil && uiImage2 != nil{
            let uiImagePublisher = ApiControl.shared.uploadImagePublisher(uiImage: uiImage)
            let uIImage2Publisher = ApiControl.shared.uploadImagePublisher(uiImage: uiImage2)
            cancellable = Publishers.Merge(uiImagePublisher, uIImage2Publisher).collect()
                .sink(receiveCompletion: { (completion) in
                    if case .failure = completion {
                        print("upImage error")
                    }
                }) {[weak self] (value) in
                    guard let self = self else { return }
                    ApiControl.shared.NewPostAPI(userID: userID, userName: userName, time: time, content: content, pictureURL: value[0].data.link, pictureURL2: value[1].data.link, location: location){
                        (result) in
                        switch result {
                        case .success( _):
                            DispatchQueue.main.async {
                                self.finish = true
                            }
                            break
                        case .failure( _):
                            break
                        }
                    }
            }
        
        }
    }
}
