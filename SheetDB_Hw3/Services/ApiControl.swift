//
//  ApiControl.swift
//  LoginRegister
//
//  Created by Joker on 2020/4/15.
//  Copyright © 2020 ntoucs. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Combine

class ApiControl{
    static let shared = ApiControl()
    
    func GetAllUserAPI(UserName:String, UserEmail:String, completion: @escaping((Result<String, NetworkError>) -> Void)) {
        let url = URL(string: "https://dev-976098.okta.com/api/v1/users?limit=200")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("SSWS 00Nv7lHk73t3tqrNP2d593tEshKK0kXWyHTLCTpc4u", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest) { (retData, res, err) in
            let decoder = JSONDecoder()
            if let retData = retData, let dic = try?decoder.decode([AllUserDec].self, from: retData), dic[0].status != ""{
                for i in 0...dic.count - 1 {
                    if dic[i].profile.login == UserName && dic[i].profile.email == UserEmail{
                        completion(.success(dic[i].id))
                        print("Get ID:" + dic[i].id)
                        break
                    }
                    else{
                        completion(.failure(NetworkError.Error))
                    }
                }
            }else{
                completion(.failure(NetworkError.Error))
                //print(String(data: retData!, encoding: .utf8))
            }
        }.resume()
    }
    
    func GetAllUserAPI(completion: @escaping((Result<[UGProfileDec], NetworkError>) -> Void)) {
        let url = URL(string: "https://dev-976098.okta.com/api/v1/users?limit=200")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("SSWS 00Nv7lHk73t3tqrNP2d593tEshKK0kXWyHTLCTpc4u", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest) { (retData, res, err) in
            let decoder = JSONDecoder()
            if let retData = retData, let dic = try?decoder.decode([UGProfileDec].self, from: retData){
                completion(.success(dic))
            }else{
                completion(.failure(NetworkError.Error))
                //print(String(data: retData!, encoding: .utf8))
            }
        }.resume()
    }
    
    func LoginAPI(LoginUserName:String, LoginPassWord:String, completion: @escaping((Result<LoginDec, NetworkError>) -> Void)){
        let url = URL(string: "https://dev-976098.okta.com/api/v1/authn")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("SSWS 00Nv7lHk73t3tqrNP2d593tEshKK0kXWyHTLCTpc4u", forHTTPHeaderField: "Authorization")
        
        struct Login: Encodable {
            var username:String
            var password:String
        }
        let userLogin = Login(username: LoginUserName, password: LoginPassWord)
        
        let jsonEncoder = JSONEncoder()
        if let data = try? jsonEncoder.encode(userLogin){
            urlRequest.httpBody = data
            URLSession.shared.uploadTask(with: urlRequest, from: data) { (retData, res, err) in
                let decoder = JSONDecoder()
                if let retData = retData, let dic = try?decoder.decode(LoginDec.self, from: retData), dic.status == "SUCCESS"{
                    completion(.success(dic))
                }else{
                    completion(.failure(NetworkError.Error))
                    //print(String(data: retData!, encoding: .utf8))
                }
            }.resume()
        }
    }
    
    func RegisterAPI(Rfirstname:String, Rlastname:String, Remail:String, Rlogin:String, Rbirthday:String, Rprofilurl:String, Rpassword:String, completion:@escaping((Result<RegisterDec, NetworkError>) -> Void)){
        let url = URL(string: "https://dev-976098.okta.com/api/v1/users?activate=true")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("SSWS 00Nv7lHk73t3tqrNP2d593tEshKK0kXWyHTLCTpc4u", forHTTPHeaderField: "Authorization")
        
        struct ProfileR: Codable{
            var firstName:String
            var lastName:String
            var email:String
            var login:String
            var birthday:String
            var profileUrl:String
        }
        
        struct Register: Encodable {
            var profile: ProfileR
            var credentials: Credentials
        }
        let userProfile = ProfileR(firstName: Rfirstname, lastName: Rlastname, email: Remail, login: Rlogin, birthday: Rbirthday, profileUrl: Rprofilurl)
        let userPassword = Password(value: Rpassword)
        let userCredentials = Credentials(password: userPassword)
        let userRegister = Register(profile: userProfile, credentials: userCredentials)
        
        let jsonEncoder = JSONEncoder()
        if let data = try? jsonEncoder.encode(userRegister){
            urlRequest.httpBody = data
            URLSession.shared.uploadTask(with: urlRequest, from: data) { (retData, res, err) in
                let decoder = JSONDecoder()
                if let retData = retData, let dic = try?decoder.decode(RegisterDec.self, from: retData), dic.status == "ACTIVE"{
                    completion(.success(dic))
                }else{
                    completion(.failure(NetworkError.Error))
                    //print(String(data: retData!, encoding: .utf8))
                }
            }.resume()
        }
    }
    
    func ChangeRecoveryQuestionAPI(UserID:String, UserPassword:String, UserRQ:String, UserRA:String, completion:@escaping((Result<String, NetworkError>) -> Void)){
        let url = URL(string: "https://dev-976098.okta.com/api/v1/users/" + UserID + "/credentials/change_recovery_question")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("SSWS 00Nv7lHk73t3tqrNP2d593tEshKK0kXWyHTLCTpc4u", forHTTPHeaderField: "Authorization")
        
        struct CRQ: Encodable{
            var password:Password
            var recovery_question: Recovery_Q
        }
        let userRecovery_Q = Recovery_Q(question: UserRQ, answer: UserRA)
        let userPassword = Password(value: UserPassword)
        let userCRQ = CRQ(password: userPassword, recovery_question: userRecovery_Q)
        
        let jsonEncoder = JSONEncoder()
        if let data = try? jsonEncoder.encode(userCRQ){
            urlRequest.httpBody = data
            URLSession.shared.uploadTask(with: urlRequest, from: data) { (retData, res, err) in
                let decoder = JSONDecoder()
                if let retData = retData, let dic = try?decoder.decode(CRQDec.self, from: retData), dic.provider.type == "OKTA"{
                    completion(.success(dic.provider.type))
                }else{
                    completion(.failure(NetworkError.Error))
                    //print(String(data: retData!, encoding: .utf8))
                }
            }.resume()
        }
        
    }
    
    func GetProfileAPI(UserID:String, completion:@escaping((Result<UGProfileDec, GetProfileError>) -> Void)){
        let url = URL(string:"https://dev-976098.okta.com/api/v1/users/" + UserID)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("SSWS 00Nv7lHk73t3tqrNP2d593tEshKK0kXWyHTLCTpc4u", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest) { (retData, res, err) in
            let decoder = JSONDecoder()
            if let retData = retData, let dic = try?decoder.decode(UGProfileDec.self, from: retData), dic.status != ""{
                completion(.success(dic))
            }else{
                completion(.failure(GetProfileError.GPErr))
                //print(String(data: retData!, encoding: .utf8))
            }
        }.resume()
    }
    
    func ModifyProfileAPI(userID: String, Mfirstname:String?, Mlastname:String?, Mprofileurl:String?, Mbirthday: String?, completion:@escaping((Result<UGProfileDec, NetworkError>)) -> Void){
        let url = URL(string: "https://dev-976098.okta.com/api/v1/users/" + userID)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("SSWS 00Nv7lHk73t3tqrNP2d593tEshKK0kXWyHTLCTpc4u", forHTTPHeaderField: "Authorization")
        
        struct Modify: Encodable {
            var profile: MProfile
        }
        let userMProfile = MProfile(firstName: Mfirstname, lastName: Mlastname, birthday: Mbirthday, profileUrl: Mprofileurl)
        let userModify = Modify(profile: userMProfile)
        
        let jsonEncoder = JSONEncoder()
        if let data = try? jsonEncoder.encode(userModify){
            urlRequest.httpBody = data
            URLSession.shared.uploadTask(with: urlRequest, from: data) { (retData, res, err) in
                let decoder = JSONDecoder()
                if let retData = retData, let dic = try?decoder.decode(UGProfileDec.self, from: retData), dic.status == "ACTIVE"{
                    completion(.success(dic))
                }else{
                    completion(.failure(NetworkError.Error))
                    //print(String(data: retData!, encoding: .utf8))
                }
            }.resume()
        }
    }
    
    func GetFollowAPI(UserID:String, completion:@escaping((Result<FollowDec, GetProfileError>) -> Void)){
        let url = URL(string:"https://dev-976098.okta.com/api/v1/users/" + UserID)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("SSWS 00Nv7lHk73t3tqrNP2d593tEshKK0kXWyHTLCTpc4u", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest) { (retData, res, err) in
            let decoder = JSONDecoder()
            if let retData = retData, let dic = try?decoder.decode(FollowDec.self, from: retData), dic.id != ""{
                completion(.success(dic))
            }else{
                completion(.failure(GetProfileError.GPErr))
                //print(String(data: retData!, encoding: .utf8))
            }
        }.resume()
    }
    
    func ModifyFollowAPI(followID: String, followArray: [String], completion:@escaping((Result<Follow, NetworkError>)) -> Void){
        let url = URL(string: "https://dev-976098.okta.com/api/v1/users/" + followID)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("SSWS 00Nv7lHk73t3tqrNP2d593tEshKK0kXWyHTLCTpc4u", forHTTPHeaderField: "Authorization")
        
        let userFArray = FollowArray(followers: followArray)
        let userFollow = Follow(profile: userFArray)
        
        let jsonEncoder = JSONEncoder()
        if let data = try? jsonEncoder.encode(userFollow){
            urlRequest.httpBody = data
            URLSession.shared.uploadTask(with: urlRequest, from: data) { (retData, res, err) in
                let decoder = JSONDecoder()
                if let retData = retData, let dic = try?decoder.decode(Follow.self, from: retData){
                    completion(.success(dic))
                }else{
                    completion(.failure(NetworkError.Error))
                    //print(String(data: retData!, encoding: .utf8))
                }
            }.resume()
        }
    }
    
    func ModifyPasswordAPI(userID:String, oldPassword:String, newPassword:String, completion:@escaping((Result<MPDDec, NetworkError>)) -> Void) {
        let url = URL(string: "https://dev-976098.okta.com/api/v1/users/" + userID + "/credentials/change_password")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("SSWS 00Nv7lHk73t3tqrNP2d593tEshKK0kXWyHTLCTpc4u", forHTTPHeaderField: "Authorization")
        
        struct MPD: Encodable{
            var oldPassword:OPD
            var newPassword:NPD
        }
        let userOPD = OPD(value: oldPassword)
        let userNPD = NPD(value: newPassword)
        let userMPD = MPD(oldPassword: userOPD, newPassword: userNPD)
        
        let jsonEncoder = JSONEncoder()
        if let data = try? jsonEncoder.encode(userMPD){
            urlRequest.httpBody = data
            URLSession.shared.uploadTask(with: urlRequest, from: data) { (retData, res, err) in
                let decoder = JSONDecoder()
                if let retData = retData, let dic = try?decoder.decode(MPDDec.self, from: retData), dic.provider.type == "OKTA"{
                    completion(.success(dic))
                }else{
                    completion(.failure(NetworkError.Error))
                    //print(String(data: retData!, encoding: .utf8))
                }
            }.resume()
        }
    }
    
    func ForgetPasswordAPI(UserID: String, completion:@escaping((Result<String, NetworkError>) -> Void)){
        let url = URL(string: "https://dev-976098.okta.com/api/v1/users/" + UserID + "/credentials/forgot_password?sendEmail=false")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("SSWS 00Nv7lHk73t3tqrNP2d593tEshKK0kXWyHTLCTpc4u", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest) { (retData, res, err) in
            let decoder = JSONDecoder()
            if let retData = retData, let dic = try?decoder.decode(FPDec.self, from: retData), dic.resetPasswordUrl != ""{
                completion(.success(dic.resetPasswordUrl))
            }else{
                completion(.failure(NetworkError.Error))
                //print(String(data: retData!, encoding: .utf8))
            }
        }.resume()
    }
    
    func uploadImage(uiImage: UIImage, completion:@escaping((Result<String, GetPhotoURLError>) -> Void)){
        //var cancellable: AnyCancellable
        let headers: HTTPHeaders = [
            "Authorization": "Client-ID f5a20294a5237b3",
        ]
        AF.upload(multipartFormData: { (data) in
            let imageData = uiImage.jpegData(compressionQuality: 0.5)
            data.append(imageData!, withName: "image")
        }, to: "https://api.imgur.com/3/upload", headers: headers).responseDecodable(of: UploadImageResult.self, queue: .main, decoder: JSONDecoder()){(response) in
            switch response.result {
            case .success(let result):
                completion(.success(result.data.link))
                print(result.data.link)
            case .failure(let error):
                completion(.failure(GetPhotoURLError.GPUErr))
                print(error)
            }
        }
    }
    
    let boundary = "Boundary-\(UUID().uuidString)"
    
    func createMultipartFormData(parameters: [[String: Any]]) -> Data {
        var postData = Data()
        
        for param in parameters {
            let paramName = param["key"]!
            postData.appendString("--\(boundary)\r\n")
            postData.appendString("Content-Disposition:form-data; name=\"\(paramName)\"")
            
            let value = param["value"]
            if value is String {
                let paramValue = param["value"] as! String
                postData.appendString("\r\n\r\n\(paramValue)\r\n")
            } else if value is UIImage {
                let uiImage = param["value"] as! UIImage
                let imageData = uiImage.jpegData(compressionQuality: 0.5)!
                let fileName = UUID().uuidString
                postData.appendString("; filename=\"\(fileName)\"\r\n"
                    + "Content-Type: \"content-type header\"\r\n\r\n")
                postData.append(imageData)
                postData.appendString("\r\n")
            }
        }
        postData.appendString("--\(boundary)--\r\n")
        return postData
    }
    
    func uploadImagePublisher(uiImage: UIImage) -> AnyPublisher<ImgurDec, Error> {
        let parameters = [
            [
                "key": "image",
                "value": uiImage
            ]]
        let postData = createMultipartFormData(parameters: parameters)
        var request = URLRequest(url: URL(string: "https://api.imgur.com/3/image")!)
        request.addValue("Client-ID f5a20294a5237b3", forHTTPHeaderField: "Authorization")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let decoder = JSONDecoder()
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: ImgurDec.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func NewPostAPI(userID:String, userName: String, time: String, content:String, pictureURL:String, pictureURL2:String, pictureURL3:String, location:String,  completion:@escaping((Result<PostDec, NetworkError>)) -> Void){
        let url = URL(string: "https://sheetdb.io/api/v1/69clm2obza0dr")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let userNewPostData = MyData(userID: userID, userName: userName, time: time, content: content, pictureURL: pictureURL, pictureURL2: pictureURL2, pictureURL3: pictureURL3, location: location)
        let userNewPost = NewPostData(data: userNewPostData)
        
        let jsonEncoder = JSONEncoder()
        if let data = try? jsonEncoder.encode(userNewPost){
            urlRequest.httpBody = data
            URLSession.shared.uploadTask(with: urlRequest, from: data) { (retData, res, err) in
                let decoder = JSONDecoder()
                if let retData = retData, let dic = try?decoder.decode(PostDec.self, from: retData), dic.created == 1{
                    completion(.success(dic))
                    print("Post Success.")
                }else{
                    completion(.failure(NetworkError.Error))
                    //print(String(data: retData!, encoding: .utf8))
                }
            }.resume()
        }
    }
    
    func GetAllPostAPI(completion:@escaping((Result<[MyData], NetworkError>)) -> Void){
        let url = URL(string: "https://sheetdb.io/api/v1/69clm2obza0dr")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        URLSession.shared.dataTask(with: urlRequest) { (retData, res, err) in
            let decoder = JSONDecoder()
            if let retData = retData, let dic = try?decoder.decode([MyData].self, from: retData), dic[0].content != ""{
                completion(.success(dic))
            }else{
                completion(.failure(NetworkError.Error))
                //print(String(data: retData!, encoding: .utf8))
            }
        }.resume()
    }
    
    func GetYourAttractions(lat:String, long:String, completion:@escaping((Result<Attractions, NetworkError>)) -> Void) {
        let url = URL(string: "https://www.travel.taipei/open-api/zh-tw/Attractions/All?nlat=" + lat + "&elong=" + long + "&page=1")
        var urlRequest = URLRequest(url: url!)
        urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "accept")
        URLSession.shared.dataTask(with: urlRequest) { (retData, res, err) in
            let decoder = JSONDecoder()
            if let retData = retData, let dic = try?decoder.decode(Attractions.self, from: retData){
                completion(.success(dic))
            }else{
                completion(.failure(NetworkError.Error))
                //print(String(data: retData!, encoding: .utf8))
            }
        }.resume()
        
    }
    
}

extension Data {
    mutating func appendString(_ string: String) {
        append(string.data(using: .utf8)!)
    }
}
